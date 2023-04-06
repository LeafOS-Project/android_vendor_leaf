#!/usr/bin/env python
#
# Copyright (C) 2022 LeafOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

from __future__ import print_function

import argparse
import os
import sys
import yaml
from xml.etree import ElementTree

local_manifest_dir = ".repo/local_manifests"
local_manifest = f"{local_manifest_dir}/local_manifest.xml"
leaf_devices = "leaf/devices/devices.yaml"

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("target_device", nargs="?", help="Target device")
    parser.add_argument("-l", "--list", help="List all supported devices", action="store_true")
    return parser.parse_args()

def load_devices():
    with open(leaf_devices) as f:
        return yaml.safe_load(f)

def get_device_info(devices, args):
    for item in devices:
        if args.list:
            for device in item["device"]:
                print(device)
            continue
        if args.target_device in item["device"]:
            return item["repositories"], item["family"]
    return None, None

def update_local_manifest(repositories):
    os.makedirs(local_manifest_dir, exist_ok=True)
    try:
        lm = ElementTree.parse(local_manifest).getroot()
    except:
        lm = ElementTree.Element("manifest")

    for repo in repositories:
        repo_name = repo["name"]
        repo_path = repo["path"]
        if any(
            localpath.get("path") == repo_path for localpath in lm.findall("project")
        ):
            continue
        project = ElementTree.Element(
            "project", attrib={"path": repo_path, "name": repo_name}
        )
        if "revision" in repo:
            project.set("revision", repo["revision"])
        if "remote" in repo:
            project.set("remote", repo["remote"])
        lm.append(project)

    ElementTree.indent(lm, space="  ", level=0)

    with open(local_manifest, "w") as f:
        f.write(ElementTree.tostring(lm).decode())

def sync_repositories(repositories):
    for repo in repositories:
        repo_path = repo["path"]
        print(f"Syncing {repo_path}")
        os.system(f"repo sync --force-sync {repo_path}")
        print("\n")

def main():
    args = parse_args()
    devices = load_devices()
    repositories, family = get_device_info(devices, args)
    if not repositories:
        if not args.list:
            print("Device not found")
        sys.exit()
    update_local_manifest(repositories)
    sync_repositories(repositories)

if __name__ == "__main__":
    main()

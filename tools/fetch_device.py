#!/usr/bin/env python
#
# Copyright (C) 2022-2023 LeafOS Project
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
import glob
import os
import yaml
import xml.etree.ElementTree as ET

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("target_device", nargs="?", help="Target device")
    parser.add_argument("-l", "--list", help="List all supported devices", action="store_true")
    parser.add_argument("-t", "--topdir", help="Set the path to the source code directory")
    return parser.parse_args()

def load_devices(leaf_devices):
    with open(leaf_devices) as f:
        return yaml.safe_load(f)

def get_device_info(devices, args):
    if args.list:
        for item in devices:
            for device in item["device"]:
                print(device)
        return None, None

    for item in devices:
        if args.target_device in item["device"]:
            return item["repositories"], item["family"]

    print("Device not found")
    return None, None

def repo_is_in_manifest(local_manifests, repo_path):
    for path in glob.glob(f"{local_manifests}/*.xml"):
        tree = ET.parse(path).getroot()

        if any(localpath.get("path") == repo_path for localpath in tree.findall("project")):
            return True

def update_local_manifest(local_manifest, repositories):
    local_manifests = os.path.dirname(local_manifest)
    os.makedirs(local_manifests, exist_ok=True)

    try:
        tree = ET.parse(local_manifest).getroot()
    except:
        tree = ET.Element("manifest")

    for repo in repositories:
        repo_name = repo["name"]
        repo_path = repo["path"]
        if repo_is_in_manifest(local_manifests, repo_path):
            continue
        project = ET.Element("project", attrib={"path": repo_path, "name": repo_name})
        if "revision" in repo:
            project.set("revision", repo["revision"])
        if "remote" in repo:
            project.set("remote", repo["remote"])
        tree.append(project)

    ET.indent(tree, space="  ", level=0)

    with open(local_manifest, "w", encoding="utf-8") as f:
        f.write(ET.tostring(tree, encoding="unicode"))

def sync_repositories(topdir, repositories):
    for repo in repositories:
        repo_path = repo["path"]
        print(f"Syncing {repo_path}")
        os.system(f"repo sync --force-sync {topdir}/{repo_path}")
        print("\n")

def main():
    args = parse_args()
    topdir = args.topdir or os.getcwd()
    leaf_devices = f"{topdir}/leaf/devices/devices.yaml"

    devices = load_devices(leaf_devices)
    repositories, family = get_device_info(devices, args)

    if repositories:
        local_manifests = f"{topdir}/.repo/local_manifests"
        local_manifest = f"{local_manifests}/{family}.xml"
        update_local_manifest(local_manifest, repositories)
        sync_repositories(topdir, repositories)

if __name__ == "__main__":
    main()

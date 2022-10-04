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

import os
import sys
import yaml
from xml.etree import ElementTree

target_device = sys.argv[1]
topdir = sys.argv[2]

if not target_device:
	print('Usage: fetch_device <codename>')
	sys.exit(1)

os.makedirs(f'{topdir}/.repo/local_manifests', exist_ok=True)

with open(f'{topdir}/leaf/devices/devices.yaml') as leaf_devices:
	data = yaml.safe_load(leaf_devices)
	for item in data:
		for device in item['device']:
			if device == target_device:
				repositories = item['repositories']
				family = item['family']

if not 'repositories' in locals():
	print('Device not found')
	sys.exit(1)

with open(f'{topdir}/.repo/local_manifests/{family}.xml', 'w') as local_manifest:
	lm = ElementTree.Element('manifest')

	for repo in repositories:
		repo_name = repo['name']
		repo_path = repo['path']

		project = ElementTree.Element('project', attrib = { 'path': repo_path, 'name': repo_name })
		if 'revision' in repo:
			project.set('revision', repo['revision'])
		if 'remote' in repo:
			project.set('remote', repo['remote'])

		lm.append(project)

	ElementTree.indent(lm, space='  ', level=0)
	local_manifest.write(ElementTree.tostring(lm).decode())

for repo in repositories:
	repo_path = repo['path']
	print(f'Syncing {repo_path}')
	os.system(f'repo sync {repo_path}')
	print('\n')

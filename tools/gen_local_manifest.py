import json, sys, os

device = sys.argv[1]
topdir = sys.argv[2]

data = json.load(open(f'{topdir}/leaf/devices/devices.json'))

for item in data:
	if item.get('device') == device:
		repositories = item['repositories']

repo_tmp = open(f'{topdir}/.repositories.tmp', 'w')

with open('.repo/manifests/local_manifests/device.xml', 'w') as local_manifest:
	print('<manifest>', file = local_manifest)

	for repo in repositories:
		repo_path = repo.split('/')[1].split('_')[1:]
		repo_path = '/'.join(repo_path)
		print(f'  <project path="{repo_path}" name="{repo}" />', file = local_manifest)
		print(f'{repo_path}', file = repo_tmp)

	print('</manifest>', file = local_manifest)

repo_tmp.close()

with open(f'{topdir}/.repositories.tmp') as repositories:
	for repo in repositories:
		os.system(f'repo sync {repo}')

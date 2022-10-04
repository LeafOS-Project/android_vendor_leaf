import os, re, sys, yaml

target_device = sys.argv[1]
topdir = sys.argv[2]

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
	exit()

with open(f'{topdir}/.repo/manifests/snippets/leaf.xml') as leaf_manifest:
	for line in leaf_manifest:
		if line.find('<default revision') != -1:
			leaf_version = re.split('"|/', line)[3]

with open(f'{topdir}/.repo/local_manifests/{family}.xml', 'w') as local_manifest:
	print('<manifest>', file = local_manifest)

	for repo in repositories:
		repo_name = repo['name']
		repo_path = repo['path']
		try:
			repo_fetch = repo['fetch']
		except:
			repo_fetch = "https://github.com/"
		try:
                        repo_revision = repo['revision']
		except:
			repo_revision = leaf_version

		print(f'  <project path="{repo_path}" name="{repo_name}" fetch="{repo_fetch}" revision="{repo_revision}" />', file = local_manifest)

	print('</manifest>', file = local_manifest)

for repo in repositories:
	repo_path = repo['path']
	print(f'Syncing {repo_path}')
	os.system(f'repo sync {repo_path}')
	print('\n')

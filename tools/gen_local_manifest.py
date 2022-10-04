import yaml, sys, os

LEAF_VERSION = "leaf-2.0"

target_device = sys.argv[1]
topdir = sys.argv[2]

os.makedirs(f'{topdir}/.repo/manifests/local_manifests', exist_ok=True)

data = yaml.safe_load(open(f'{topdir}/leaf/devices/devices.yaml'))

for item in data:
	for device in item['device']:
		if device == target_device:
			repositories = item['repositories']
			family = item['family']

if not 'repositories' in locals():
	print('Device not found')
	exit()

with open(f'{topdir}/.repo/local_manifests/{family}.xml', 'w') as local_manifest:
	print('<manifest>', file = local_manifest)

	for repo in repositories:
		repo_name = repo['name']
		repo_path = repo['path']
		try:
			repo_fetch = repo['fetch']
			repo_revision = repo['revision']
		except:
			repo_fetch = "https://github.com/"
			repo_revision = LEAF_VERSION

		print(f'  <project path="{repo_path}" name="{repo_name}" fetch="{repo_fetch}" revision="{repo_revision}" />', file = local_manifest)

	print('</manifest>', file = local_manifest)

for repo in repositories:
	repo_path = repo['path']
	os.system(f'repo sync {repo_path}')

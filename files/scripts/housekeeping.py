def deleteApplication(app):
    try:
        print "Deleting " + app
        repository.delete(app)
        print "Ok."
    except:
        print "Fail."
        pass

apps = repository.search('udm.Application')

for app in apps:
    packages = repository.search('udm.DeploymentPackage', app)
    packages_padded = {}
    for package in packages:
        rawversion = package.split('/')[2]
        if "-" in rawversion:
            version = rawversion.split('-')[0]
        else:
            version = rawversion
        if version.count('.') == 3:
            version_padded = version.split('.')[0].zfill(3) + "." + version.split('.')[1].zfill(3) + "." + version.split('.')[2].zfill(3) + "." + version.split('.')[3].zfill(3)
        elif version.count('.') == 2:
            version_padded = version.split('.')[0].zfill(3) + "." + version.split('.')[1].zfill(3) + "." + version.split('.')[2].zfill(3) + ".000"
        else:
            print "Cannot handle version number " + rawversion

        if "-" in rawversion:
            version_padded = version_padded + '-' + rawversion.split('-')[1]

        packages_padded[version_padded] = package

    s = sorted(packages_padded.items())
    if len(s) > 5:
        for (key, value) in s[:len(s)-5]:
            deleteApplication(value)

deployit.runGarbageCollector()

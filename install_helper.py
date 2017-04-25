import json
import platform
import sys

# install_helper reads the JSON payload from stdin and prints the URL for the
# zipfile for the correct OS/architecture. Exits with 0 if a URL was found, 1
# otherwise. This script expects data in the format found at:
# https://api.github.com/repos/google/protobuf/releases/latest.
if __name__ == '__main__':
    my_uname_data = platform.uname()
    my_os = my_uname_data[0]  # Darwin, Linux, Windows, etc.
    my_arch = my_uname_data[4]  # x86_64, etc.

    search_os = ''
    search_arch = my_arch

    # Need to set the search OS (and possibly architecture) depending on the
    # given results from the platform package.
    if my_os == 'Darwin':
        search_os = 'osx-'
    elif my_os == 'Linux':
        search_os = 'linux-'
    elif my_os == 'Windows':
        search_os = 'win32'
        search_arch = ''

    # Exit if we don't know what to search for.
    if not search_os:
        sys.stderr.write('Unknown OS "%s"\n' % my_os)
        exit(1)

    # Read the JSON payload from stdin; we only care about the assets for
    # zipfile downloads.
    payload = json.load(sys.stdin)
    assets = payload['assets']

    search_str = '%s%s.zip' % (search_os, search_arch)

    zip_url = ''
    for asset in assets:
        name = asset['name']
        if 'protoc' in name and search_str in name:
            zip_url = asset['browser_download_url']
            break

    sys.stdout.write(zip_url)

    exit_status = 0 if zip_url else 1
    exit(exit_status)

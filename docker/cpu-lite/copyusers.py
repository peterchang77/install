import os, re, argparse

USAGE = """
USAGE: python copyeusers.py [-src ... , -dst ...] 

Run COVID-19 predictive analytics 

OPTIONS:

  -src          SRC directory containing users data (default is ~/etc)
  -dst          DST directory containing users data (default is /etc)

"""

def copy_users(src=None, dst=None):

    SRC_DIR = src or '{}/etc'.format(os.environ['HOME'])
    DST_DIR = dst or '/etc'

    passwd = '{}/passwd'.format(SRC_DIR)
    if not os.path.exists(passwd):
        return

    users = find_users(passwd)

    # --- Update passwd
    copy_lines('{}/passwd'.format(DST_DIR), users)

    # --- Update remainder
    for key in ['shadow', 'group', 'gshadow']:
        src = '{}/{}'.format(SRC_DIR, key)
        dst = '{}/{}'.format(DST_DIR, key)
        if os.path.exists(src):
            lines = find_lines(src, users)
            copy_lines(dst, lines)

def find_users(passwd):

    users = {}

    with open(passwd, 'r') as f:
        for line in f.readlines():
            matches = re.findall('^[a-zA-Z].*:x:1[0-9][0-9][0-9]:1[0-9][0-9][0-9]:', line)
            if len(matches) > 0:
                users[matches[0].split(':')[0]] = line 

    return users

def find_lines(fname, users):

    lines = {}

    with open(fname, 'r') as f:
        for line in f.readlines():
            if line.split(':')[0] in users:
                lines[line.split(':')[0]] = line

    return lines

def copy_lines(fname, lines):

    # --- Find existing users
    if os.path.exists(fname):
        users = {line.split(':')[0]: line for line in open(fname, 'r').readlines()}
    else:
        users = {}
        os.makedirs(os.path.dirname(fname), exist_ok=True)

    # --- Update
    with open(fname, 'a+') as f:
        for user, line in lines.items():
            if user not in users:
                f.write(line)

if __name__ == '__main__':

    parser = argparse.ArgumentParser(usage=USAGE)
    parser.add_argument('-src', metavar='src', type=str, default=None)
    parser.add_argument('-dst', metavar='dst', type=str, default=None)

    args = parser.parse_args()
    copy_users(**vars(args))

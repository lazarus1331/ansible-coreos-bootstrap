#/bin/bash

set -e

if [[ -e $HOME/.bootstrapped ]]; then
  exit 0
fi

# get portable version of 2.7
wget -q -O - https://bitbucket.org/squeaky/portable-pypy/downloads/pypy-4.0.1-linux_x86_64-portable.tar.bz2 | tar -xjf -

mv -n pypy-4.0.1-linux_x86_64-portable pypy

## library fixup
ln -snf /lib64/libncurses.so.5.9 $HOME/pypy/lib/libtinfo.so.5

mkdir -p $HOME/bin

cat > $HOME/bin/python <<EOF
#!/bin/bash
LD_LIBRARY_PATH=$HOME/pypy/lib:$LD_LIBRARY_PATH $HOME/pypy/bin/pypy "\$@"
EOF

# override .bashrc to include home bin in $PATH (fixes copy-pip.py failing to find python)
rm $HOME/.bashrc
cat > $HOME/.bashrc <<EOF
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi
EOF

chmod +x $HOME/bin/python
$HOME/bin/python --version

touch $HOME/.bootstrapped

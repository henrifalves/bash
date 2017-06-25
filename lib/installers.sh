
update_code_jumpscale() {
    local branch="${1:-master}"
    echo "[+] loading or updating jumpscale source code (branch:$branch)"
    ZGetCodeJS -r core9 -b $branch > ${ZLogFile} 2>&1 || die
    popd
    ZGetCodeJS -r lib9 -b $branch > ${ZLogFile} 2>&1 || die
    popd
    ZGetCodeJS -r prefab9 -b $branch > ${ZLogFile} 2>&1 || die
    popd
    ZGetCodeJS -r builder_bootstrap -b $branch > ${ZLogFile} 2>&1 || die
    popd
    ZGetCodeJS -r developer -b $branch > ${ZLogFile} 2>&1 || die
    popd
    echo "[+] update jumpscale code done"
}

installjs9() {
    echo "[+] install js9"
    # ZSSH "ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts"
    echo "[+]   synchronizing developer files"
    container rsync -rv /opt/code/jumpscale/developer/files_guest/ /

    echo "[+]   installing jumpscale core9"
    container pip3 install -e /opt/code/jumpscale/core9

    echo "[+]   installing binaries files"
    container 'find  /opt/code/github/jumpscale/core9/cmds -exec ln -s {} "/usr/local/bin/" \;'
    container 'find  /opt/code/github/jumpscale/developer/cmds_guest -exec ln -s {} "/usr/local/bin/" \;'

    container rm -rf /usr/local/bin/cmds
    container rm -rf /usr/local/bin/cmds_guest

    echo "[+]   initializing jumpscale part3"
    container 'python3 -c "from JumpScale9 import j; j.do.initEnv()"'
    container 'python3 -c "from JumpScale9 import j; j.tools.jsloader.generate()"'

    echo "[+] js9 installed (OK)"

}

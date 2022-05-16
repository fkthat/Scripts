function FindProxyForURL(url, host) {
    let useProxyFor = [
       /(^|\.)bbc\./,
       /(^|\.)meduza\./,
       /(^|\.)xuk\./,
       /(^|\.)xukru\./,
       /(^|\.)lostfilm\./
    ];

    for(i in useProxyFor) {
        if(useProxyFor[i].test(host)) {
             return "SOCKS5 localhost:9050"
        }
    }

    return "DIRECT";
}

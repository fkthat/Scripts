// ==UserScript==
// @name         Gallifrey autologon
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  Autologon to my router (Gallifrey)
// @author       You
// @match        http://gallifrey/
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    var userName = document.getElementById('userName');
    var password = document.getElementById('pcPassword');

    if(userName && password) {
        userName.value = '***';
        password.value = '***';
        window.PCSubWin();
    }
})();
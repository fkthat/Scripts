// ==UserScript==
// @name         No Smuzy
// @namespace    http://tampermonkey.net/
// @version      0.1
// @author       FkThat
// @match        https://www.sql.ru/forum/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    let mudachje = ['Смузи'];
    document.querySelectorAll('.msgTable').forEach(el => {
        var el1 = el.querySelector('.msgBody');
        if(mudachje.find(m => el1.innerText.indexOf(m) > -1)) {
            el.style.display = 'none';
        }
    });
})();
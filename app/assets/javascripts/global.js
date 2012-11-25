var GLOBAL = GLOBAL || {};

/*
 * Usage:
 * var constants = GLOBAL.namespace('GLOBAL.constants');
 */

GLOBAL.namespace = function (ns_string) {
    var parts = ns_string.split('.'), parent = GLOBAL, i;
    // strip redundant leading global
    if (parts[0] === "GLOBAL") {
        parts = parts.slice(1);
    }
    for (i = 0; i < parts.length; i += 1) {
    // create a property if it doesn't exist
        if (typeof parent[parts[i]] === "undefined") {
            parent[parts[i]] = {};
        }
        parent = parent[parts[i]];
    }
    return parent;
};

#!/usr/bin/env python
import glob
import os
import re


FUNCTION = re.compile(r'^(function\s)', re.MULTILINE)
VAR = re.compile(r'^(var\s)', re.MULTILINE)
OBJ_COMMA = re.compile(r',(\s*)\}')
VAR_CLASS = re.compile(r'^\s+public var ([^\s]+)\s*:\s*([^;]+);', re.MULTILINE)

FUNC = re.compile(r'^public function\s+([^\(]+)', re.MULTILINE)


def main():
    d = 'com/reversefold/glitch/server/player/'
    files = glob.glob(os.path.join(d, '*.as'))
    var_names = {}
    with open(os.path.join(d, 'Player.as'), 'r') as f:
        data = f.read()
        for m in VAR_CLASS.finditer(data):
            var_names[m.group(2)] = m.group(1)
    funcs = {}
    for fn in files:
        print 'Scanning ' + fn
        class_name = os.path.splitext(os.path.basename(fn))[0]
        var_name = ('' if class_name == 'Player' else (var_names[class_name] + '.'))
        with open(fn, 'r') as f:
            orig = data = f.read()
        data = FUNCTION.sub(r'public \1', data)
        data = VAR.sub(r'public \1', data)
        data = OBJ_COMMA.sub(r'\1}', data)
        if data != orig:
            print '  Fixing ' + fn
            with open(fn, 'w') as f:
                f.write(data)
        for m in FUNC.finditer(data):
            func = m.group(1)
            if func in funcs:
                raise Exception('Duplicate func ' + func + ' ' + funcs[func])
            funcs[func] = (class_name, ('player.' + var_name + func))
            print '\tfound %s: %s' % (func, funcs[func],)
    for fn in files:
        class_name = os.path.splitext(os.path.basename(fn))[0]
        with open(fn, 'r') as f:
            orig = data = f.read()
        for fnd, (var_class_name, rpl) in funcs.iteritems():
            if class_name == var_class_name:
                continue
            data = data.replace('this.' + fnd, 'this.' + rpl)
        if data != orig:
            print '  Fixing ' + fn
            with open(fn, 'w') as f:
                f.write(data)


if __name__ == '__main__':
    main()

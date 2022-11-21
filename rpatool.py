#!/usr/bin/env python
from __future__ import print_function
import sys
import os
sys.path.append('..')
import renpy.object
import renpy.config
import renpy.loader
try:
    import renpy.util
except:
    pass
class RenPyArchive:
    file = None
    handle = None

    files = {}
    indexes = {}

    def __init__(self, file):
        self.load(file)

    # Converts a filename to archive format.
    def convert_filename(self, filename):
        (drive, filename) = os.path.splitdrive(os.path.normpath(filename).replace(os.sep, '/'))
        return filename


    # List files in archive and current internal storage.
    def list(self):
        return list(self.indexes)

    # Read file from archive or internal storage.
    def read(self, filename):
        filename = self.convert_filename(filename)
        if(isinstance(self.indexes[filename], list)):
            try:
                (offset, length, prefix) = self.indexes[filename][0][0:3]
            except Exception:
                (offset, length) = self.indexes[filename][0][0:2]
                prefix = ''
            if not isinstance(prefix, bytes):
                prefix = prefix.encode("latin-1")
            self.handle.seek(offset)
            return prefix + self.handle.read(length - len(prefix))
        else: return None

    # Load archive.
    def load(self, filename):
        self.file = filename
        self.files = {}
        self.handle = open(self.file, 'rb')
        base, ext = filename.split(".")
        renpy.config.archives.append(base)
        renpy.config.searchpath = [os.path.dirname(os.path.realpath(self.file))]
        renpy.config.basedir = os.path.dirname(renpy.config.searchpath[0])
        renpy.loader.index_archives()
        items = renpy.loader.archives[0][1].items()
        for file, index in items:
            self.indexes[file] = index

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(
        description='A tool for working with Ren\'Py archive files.',
        epilog='The FILE argument can optionally be in ARCHIVE=REAL format, mapping a file in the archive file system to a file on your real file system. An example of this: rpatool -x test.rpa script.rpyc=/home/foo/test.rpyc',
        add_help=False)

    parser.add_argument('archive', metavar='ARCHIVE', help='The Ren\'py archive file to operate on.')
    arguments = parser.parse_args()
    archive = arguments.archive
    output = '.'
    # try:
    archive = RenPyArchive(archive)

    files = archive.list()

    # Create output directory if not present.
    if not os.path.exists(output):
        os.makedirs(output)

    # Iterate over files to extract.
    for filename in files:
        outfile = filename
        contents = archive.read(filename)
        if(None != contents):
            # Create output directory for file if not present.
            if not os.path.exists(os.path.dirname(os.path.join(output, outfile))):
                os.makedirs(os.path.dirname(os.path.join(output, outfile)))

            with open(os.path.join(output, outfile), 'wb') as file:
                file.write(contents)
    # except Exception as err:
    #     print(err)
    #     sys.exit(1)

#!/usr/bin/python

"""

Read LD blocks and write as hdf5

"""

import scipy as sp
import numpy as np
import h5py
from os import path

BLK_DIR = '/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/blk'

OUT_DIR = '/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/ldblk_1kg_eur'

with open('/net/mulan/disk2/yasheng/comparisonProject-archieve/LDblock_EUR/blk_size') as ff:
    blk_size = [int(line.strip()) for line in ff]

for chr in range(21):
    chrom = chr + 1
    print('... parse chomosome %d ...' % chrom)
    chr_name = OUT_DIR + '/ldblk_1kg_chr' + str(chrom) + '.hdf5'
    hdf_chr = h5py.File(chr_name, 'w')
    blk_cnt = 0
    n_blk = blk_size[chrom-1]
    for blk in range(n_blk):
        print('... parse blk %d ...' % blk)
        blk_file = BLK_DIR + '/chr' + str(chrom) + '_blk' + str(blk+1) + '.ld'
        if path.exists(blk_file):
            with open(blk_file) as ff:
                ld = [[float(val) for val in (line.strip()).split()] for line in ff]
            print('blk %d size %s' % (blk+1, sp.shape(ld)))
            snp_file = BLK_DIR + '/chr' + str(chrom) + '_blk' + str(blk+1) + '.snp'
            with open(snp_file) as ff:
                snplist = [line.strip() for line in ff]
            blk_cnt += 1
            hdf_blk = hdf_chr.create_group('blk_%d' % blk_cnt)
            hdf_blk.create_dataset('ldblk', data=sp.array(ld), compression="gzip", compression_opts=9)
            hdf_blk.create_dataset('snplist', data=np.string_(snplist), compression="gzip", compression_opts=9)

chrom = 22
print('... parse chomosome %d ...' % chrom)
chr_name = OUT_DIR + '/ldblk_1kg_chr' + str(chrom) + '.hdf5'
hdf_chr = h5py.File(chr_name, 'w')
blk_cnt = 0
n_blk = blk_size[chrom-1]
for blk in range(n_blk):
    print('... parse blk %d ...' % blk)
    blk_file = BLK_DIR + '/chr' + str(chrom) + '_blk' + str(blk+1) + '.ld'
    if path.exists(blk_file):
        with open(blk_file) as ff:
            ld = [[float(val) for val in (line.strip()).split()] for line in ff]
        print('blk %d size %s' % (blk+1, sp.shape(ld)))
        snp_file = BLK_DIR + '/chr' + str(chrom) + '_blk' + str(blk+1) + '.snp'
        with open(snp_file) as ff:
            snplist = [line.strip() for line in ff]
        blk_cnt += 1
        hdf_blk = hdf_chr.create_group('blk_%d' % blk_cnt)
        hdf_blk.create_dataset('ldblk', data=sp.array(ld), compression="gzip", compression_opts=9)
        hdf_blk.create_dataset('snplist', data=np.string_(snplist), compression="gzip", compression_opts=9)


file_name="/net/mulan/disk2/yasheng/comparisonProject/04_reference/hm3/ldblk_1kg_eur/ldblk_1kg_chr1.hdf5"
import h5py
f = h5py.File(file_name, "r+")

group = f["blk_1"]
data = group["snplist"].value
sp.shape(data)
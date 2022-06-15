# -*- coding:utf-8 -*-
import sys
import os
import random
import struct
import argparse
from Crypto.Cipher import AES

AES_BLOCK_SIZE = AES.block_size
KEY = 'aes'


def padding_bytes(_bytes):
    diff = len(_bytes) % AES_BLOCK_SIZE
    if diff == 0:
        return _bytes
    diff = AES_BLOCK_SIZE - diff
    padding_str = ''.join(' ' for i in range(diff))
    return _bytes + padding_str.encode()


def padding_key(_key):
    if len(_key) > AES_BLOCK_SIZE:
        return _key[:AES_BLOCK_SIZE]
    diff = AES_BLOCK_SIZE - len(_key) % AES_BLOCK_SIZE
    padding_str = ''.join(' ' for i in range(diff))
    return _key + padding_str


def encrypt(key, file, chunk_size=4 * 1024):
    iv = ''.join(chr(random.randint(0x61, 0x7A)) for i in range(AES_BLOCK_SIZE)).encode('utf-8')
    key = padding_key(key)
    _encrypt = AES.new(key.encode('utf-8'), AES.MODE_CBC, iv)
    file_size = os.path.getsize(file)
    output = f'{file}.dat'
    with open(file, 'rb') as input_file:
        with open(output, 'wb') as output_file:
            output_file.write(struct.pack('<Q', file_size))
            output_file.write(iv)
            while True:
                file_chunk = input_file.read(chunk_size)
                if len(file_chunk) == 0:
                    break
                _bytes = padding_bytes(file_chunk)
                output_file.write(_encrypt.encrypt(_bytes))


def decrypt(key, file, chunk_size=4 * 1024):
    output = os.path.splitext(file)[0]
    key = padding_key(key)
    with open(file, 'rb') as input_file:
        original_size = struct.unpack('<Q', input_file.read(struct.calcsize('Q')))[0]
        iv = input_file.read(AES_BLOCK_SIZE)
        key = key.encode('utf-8')
        _decrypt = AES.new(key, AES.MODE_CBC, iv)
        with open(output, 'wb') as output_file:
            while True:
                file_chunk = input_file.read(chunk_size)
                if len(file_chunk) == 0:
                    break
                output_file.write(_decrypt.decrypt(file_chunk))
            output_file.truncate(original_size)


def parser_args(args):
    parser = argparse.ArgumentParser(description='文件加密解密')
    parser.add_argument('-e', '--encrypt', type=str, help='需要加密的文件路径', default=None, dest='encrypt')
    parser.add_argument('-d', '--decrypt', type=str, help='需要解密的文件路径', default=None, dest='decrypt')

    return parser.parse_args()


if __name__ == '__main__':
    arg_parser = parser_args(sys.argv[1:])

    if arg_parser.encrypt:
        if not os.path.isfile(arg_parser.encrypt):
            print(f'no such file: {arg_parser.encrypt}')
        else:
            encrypt(KEY, arg_parser.encrypt)
    if arg_parser.decrypt:
        if not os.path.isfile(arg_parser.decrypt):
            print(f'no such file: {arg_parser.decrypt}')
        else:
            decrypt(KEY, arg_parser.decrypt)

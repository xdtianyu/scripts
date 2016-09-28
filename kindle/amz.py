#!/usr/bin/env python3
import time as t
import os
import re
from urllib.error import HTTPError

from amazon.api import AmazonAPI

import config
from node import Node

cache_dir = 'cache/'


def write_query_to_db(cache_url, data):
    if not os.path.exists(cache_dir):
        os.mkdir(cache_dir)

    file = cache_dir + re.match('.*ItemId=(.*)&Operation', cache_url).group(1) + '.xml'
    f = open(file, 'wb')
    f.write(data)


def read_query_from_db(cache_url):
    file = cache_dir + re.match('.*ItemId=(.*)&Operation', cache_url).group(1) + '.xml'
    if os.path.exists(file) and t.time() - os.path.getmtime(file) < 100 * 24 * 60 * 60 * 1000:
        f = open(file, 'rb')
        return f.read()
    return None


amazon = AmazonAPI(config.KEY_ID, config.SECRET_KEY, config.TAG,
                   region='CN', MaxQPS=0.9, CacheReader=read_query_from_db, CacheWriter=write_query_to_db)


def lookup(book):
    while True:
        try:
            product = amazon.lookup(ItemId=book.item_id)

            book.author = product.author
            book.pages = product.pages
            book.publisher = product.publisher
            book.brand = product.brand
            book.asin = product.asin
            book.binding = product.binding
            book.edition = product.edition
            book.editorial_review = product.editorial_review
            book.isbn = product.isbn
            book.large_image_url = product.large_image_url
            book.region = product.region
            book.release_date = product.release_date.strftime("%Y-%m-%d")
            if product.publication_date:
                book.publication_date = product.publication_date.strftime("%Y-%m-%d")
            book.sales_rank = product.sales_rank
            book.medium_image_url = product.medium_image_url
            book.small_image_url = product.small_image_url
            if product.languages:
                book.languages = list(product.languages)

            book.nodes = []
            for browse_node in product.browse_nodes:
                node = Node()
                book.nodes.append(node)
                while True:
                    node.id = browse_node.id
                    node.name = str(browse_node.name)
                    if not browse_node.is_category_root:
                        node.node = Node()
                        node = node.node
                        browse_node = browse_node.ancestor
                    else:
                        node.is_root = True
                        break

            print('cached: ' + book.item_id + ' -> ' + book.title)
            break
        except HTTPError as e:
            print(e)
            t.sleep(3)
            pass

#!/usr/bin/env python3
import io
import json
import os
import re
import time as t
from urllib.error import HTTPError

from amazon.api import AmazonAPI
import requests
from bs4 import Tag

import config
from book import Book

cache_dir = 'cache/'


def write_query_to_db(cache_url, data):

    if not os.path.exists(cache_dir):
        os.mkdir(cache_dir)

    file = cache_dir + re.match('.*ItemId=(.*)&Operation', cache_url).group(1) + '.xml'
    f = open(file, 'wb')
    f.write(data)


def read_query_from_db(cache_url):
    file = cache_dir + re.match('.*ItemId=(.*)&Operation', cache_url).group(1) + '.xml'
    if os.path.exists(file) and os.path.getmtime(file) > t.time() - 20 * 60 * 60 * 1000:
        f = open(file, 'rb')
        return f.read()
    return None


amazon = AmazonAPI(config.AWS_ACCESS_KEY_ID, config.AWS_SECRET_ACCESS_KEY, config.AWS_ASSOCIATE_TAG,
                   region='CN', MaxQPS=0.9, CacheReader=read_query_from_db, CacheWriter=write_query_to_db)

user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko)Chrome/50.0.2661.75 Safari/537.36'

header = {'User-Agent': user_agent}


def fetch(url, headers, cookies):
    r = requests.get(url, headers=headers, cookies=cookies)
    from bs4 import BeautifulSoup
    import lxml

    bs = BeautifulSoup(r.text, lxml.__name__)

    time = re.match('数据更新于：(.*)', bs.find('span', style='color:#FFF9A8').text).group(1)

    kindle = {'time': time, 'books': []}

    book_items = bs.find_all('div', style='margin-bottom: 0.9em;')

    for book_item in book_items:

        book = Book()

        if isinstance(book_item, Tag):
            a = book_item.find('a')
            min_day = book_item.find('span', title=re.compile('最近在')).get('title')
            book.min_day = re.match('最近在(.*)达到最低价', min_day).group(1)

            if isinstance(a, Tag):
                book.url = 'https' + re.match('http(.*)/ref', a.get('href')).group(1)
                book.item_id = re.match('.*product/(.*)/ref', a.get('href')).group(1)
                book.title = a.get('title')

            matches = re.match('.*历史均价：￥(.*)，现价：￥(.*)作者：(.*)，评分：(.*)，历史最低价：￥(.*)', book_item.text)

            book.average = matches.group(1)
            book.price = matches.group(2)
            book.author = matches.group(3)
            book.score = matches.group(4)
            book.min = matches.group(5)

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
                    book.editorial_reviews = product.editorial_reviews
                    book.isbn = product.isbn
                    book.large_image_url = product.large_image_url
                    book.region = product.region
                    book.release_date = product.release_date.strftime("%Y-%m-%d")
                    book.sales_rank = product.sales_rank

                    kindle['books'].append(book)
                    print('cached: ' + book.item_id + ' -> ' + book.title)
                    break
                except HTTPError:
                    t.sleep(2)
                    pass

    with io.open('kindle.json', 'w', encoding='utf-8') as f:
        f.write(json.dumps(kindle, default=lambda o: o.__dict__, indent=2, ensure_ascii=False, sort_keys=True))

if __name__ == '__main__':
    fetch('http://t.bookdna.cn', header, {})

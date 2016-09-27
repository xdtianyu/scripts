#!/usr/bin/env python3
import io
import json
import re

import requests
from bs4 import Tag

import config
from book import Book


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

            import amz
            amz.lookup(book)

            kindle['books'].append(book)

    with io.open('kindle.json', 'w', encoding='utf-8') as f:
        f.write(json.dumps(kindle, default=lambda o: o.dump(), indent=2, ensure_ascii=False, sort_keys=True))

if __name__ == '__main__':
    fetch('http://t.bookdna.cn', config.header, {})

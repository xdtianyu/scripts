#!/usr/bin/env python3
import io
import json
import os
import re

import requests

from book import Book
import config

cn_url = 'https://www.amazon.cn/s/?rh=n:116087071,n:!116088071,n:116169071,p_36:159125071&page='
en_url = 'https://www.amazon.cn/s/?rh=n:116087071,n:!116088071,n:116169071,n:116170071,p_36:159125071&page='
base_url = 'https://www.amazon.cn/gp/product/'
page_dir = 'page/'


def fetch_free_books(url, page):
    r = requests.get(url + str(page), headers=config.header)
    from bs4 import BeautifulSoup, Tag
    import lxml

    bs = BeautifulSoup(r.text, lxml.__name__)
    items = bs.find_all('li', attrs={'class': 's-result-item celwidget'})

    kindle = {'books': []}

    for item in items:
        if isinstance(item, Tag):
            book = Book()
            book.title = item.find('h2').text
            # book.item_id = item.find('span', attrs={'name': re.compile('.*')}).get('name')
            book.item_id = item.get('data-asin')
            book.url = base_url + book.item_id
            book.average = 0
            book.price = 0
            book.min = 0
            score = item.find('span', attrs={'class': 'a-icon-alt'})
            if score:
                book.score = re.match('平均(.*) 星', score.text).group(1)

            import amz
            amz.lookup(book)

            kindle['books'].append(book)

    kindle['count'] = len(kindle['books'])
    kindle['page'] = page
    return kindle


def get_free_cn_books(page):
    kindle = fetch_free_books(cn_url, page)
    with io.open(page_dir + 'kindle_free_books_cn_' + str(page) + '.json', 'w', encoding='utf-8') as f:
        f.write(json.dumps(kindle, default=lambda o: o.dump(), indent=2, ensure_ascii=False, sort_keys=True))


def get_free_en_books(page):
    kindle = fetch_free_books(en_url, page)
    with io.open(page_dir + 'kindle_free_books_en_' + str(page) + '.json', 'w', encoding='utf-8') as f:
        f.write(json.dumps(kindle, default=lambda o: o.dump(), indent=2, ensure_ascii=False, sort_keys=True))


def get_free_books():
    if not os.path.exists(page_dir):
        os.mkdir(page_dir)

    for page in range(1, 400):
        get_free_cn_books(page)

    for page in range(1, 400):
        get_free_en_books(page)

get_free_books()

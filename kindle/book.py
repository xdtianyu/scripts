import json


class Book:
    title = ''
    average = 0
    price = 0
    author = ''
    min = 0
    score = 0
    url = ''
    min_day = ''

    item_id = None
    pages = None
    publisher = None
    brand = None
    asin = None
    binding = None
    edition = None
    editorial_review = None
    isbn = None
    large_image_url = None
    region = None
    release_date = None
    sales_rank = None
    medium_image_url = None
    publication_date = None
    small_image_url = None
    languages = None
    nodes = None

    def json(self):
        return json.dumps(self, default=lambda o: o.__dict__, indent=2, ensure_ascii=False, sort_keys=True)

    def dump(self):
        return clean_dict(self.__dict__)


def clean_dict(d):
    if not isinstance(d, dict):
        return d
    return dict((k, clean_dict(v)) for k, v in d.items() if v is not None)

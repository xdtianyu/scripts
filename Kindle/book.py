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

    def json(self):
        return json.dumps(self, default=lambda o: o.__dict__, indent=2, ensure_ascii=False, sort_keys=True)


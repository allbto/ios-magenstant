
class User(object):
    usertag = ""

    def __init__(self, usertag):
        self.usertag = usertag

    def json(self):
        return {
            "usertag" : self.usertag
        }

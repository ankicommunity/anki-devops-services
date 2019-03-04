def url_ending_with_slash(url):
    if url[-1] == "/":
        return url
    else:
        return url + "/"

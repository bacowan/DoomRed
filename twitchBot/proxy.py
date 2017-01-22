import urllib2
import cfg

def url(page, perPage):
    return cfg.URL + "/submissions?page=" + str(page) + "&per_page=" + str(perPage) + "&access_token=" + cfg.ACCESS_TOKEN

def formatResponse(response):
    ret = {}
    ret["name"] = response[0]["name"]
    return ret

def read(page, perPage):
    return urllib2.urlopen(url(page,perPage)).read()

def main():
    response = read(1,1)
    formattedResponse = formatResponse(response)
    
if __name__ == "__main__":
    main()
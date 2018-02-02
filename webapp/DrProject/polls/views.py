from django.http import HttpResponse
import sys

def index(request):
    var_info = str(sys.version_info.major)
    return HttpResponse("Hello, world. You're at the polls index. version=" + var_info)

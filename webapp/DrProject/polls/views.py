from django.http import HttpResponse
import sys
import socket

def index(request):
    var_info = str(sys.version_info.major)
    ip_add = socket.gethostbyname(socket.gethostname())
    return HttpResponse("Hello, 1 world. You're at the polls index. version=" + var_info + "ip=" + ip_add)

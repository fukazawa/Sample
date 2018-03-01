from django.http import HttpResponse
from django.http import JsonResponse
import sys
import socket
from .models import Stocks

import logging
import google.cloud.logging
client = google.cloud.logging.Client('django-nginx-dev')
client.setup_logging(logging.INFO)

def index(request):
    stock_list = Stocks.objects.all()
    stock_id = stock_list[0].id
    stock_obj = {'id': stock_id}
    logging.error('This is an error test!')
    return JsonResponse(stock_obj)

#from django.shortcuts import render
from django.template import Context, loader
from turk.models import Image, Object
from django.http import HttpResponse
# Create your views here.

def findit(request):
    
    latest_image = Image.objects.latest()
    t = loader.get_template('templates/findit.html')
    c = Context({
        'latest_image':latest_image,
    })
    
    return HttpResponse(t.render(c))    
    
def home(requst):
    
    latest_object = Object.objects.latest()
    t = loader.get_template('templates/home.html')
    c = Context({
        'latest_object':latest_object,
    })
    
    return HttpResponse(t.render(c))    
    
    
#from django.shortcuts import render
from django.template import RequestContext, loader
from turk.models import Image, Object
from django.http import HttpResponse
from nasa_turk.settings import BASE_DIR
# Create your views here.

def findit(request):
    
    latest_image = Image.objects.latest()
    t = loader.get_template('templates/findit.html')
    c = RequestContext({
#        'object_loc': BASE_DIR + 'image' + \
#            latest_image.timestamp.strftime('/%Y/%m/%d/') + \
#            latest_image.image_name,
        'latest_image':latest_image,
    })
    
    return HttpResponse(t.render(c))    
    
def home(requst):
    
    latest_object = Object.objects.latest()
    t = loader.get_template('templates/home.html')
    c = RequestContext({
#        'object_loc': BASE_DIR + 'object_image' + \
#            latest_object.timestamp.strftime('/%Y/%m/%d/') + \
#            latest_object.object_name,
        'latest_object':latest_object,
    })
    
    return HttpResponse(t.render(c))    
    
    
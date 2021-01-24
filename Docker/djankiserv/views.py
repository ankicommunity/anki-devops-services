from django.http import HttpResponse


def health(_request):
    return HttpResponse("It's great. Why, thank you for asking!\n")

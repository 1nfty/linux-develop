import requests
import random
import time
import logging

baseUrl = 'http://apps.mgreen.io:8443'

s = requests.Session()
s.headers.update({
    'token': '18621288301_406f67e6-bde7-4a1d-a336-47254b098adc',
    'deviceId': '84107bb6-dfa5-3704-862f-51008aab751d'
})

LOG_FORMAT = "%(asctime)s - %(levelname)s - %(funcName)s:%(lineno)d - %(message)s"
logging.basicConfig(filename='gc.log', level=logging.INFO, format=LOG_FORMAT)


def uploadSteps():
    payload = {'steps': random.randint(28000, 31000), 'clientType': 'IOS'}
    r = s.post(baseUrl+'/green/uploadSteps', json=payload)
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    logging.info(r.json())

def sign():
    r = s.post(baseUrl+'/user/sign')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    logging.info(r.json())

def clickBubbles():
    r = s.get(baseUrl+'/energy/bubble')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    for b in result['data']:
        bubbleId = b['bubbleId']
        r = s.post(baseUrl+'/energy/bubble/click?bubbleId=%s' % bubbleId)
        if (r.status_code != 200):
            logging.error("http error: %d", r.status_code)
            return
        logging.info(r.json())

def fertilize(plantId):
    r = s.post(baseUrl+'/plant/fertilize', json={'plantId': plantId})
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    if result['code'] == 'SUCCESS':
        fertilize(plantId)

def grownup(plantId):
    r = s.post(baseUrl+'/plant/grownup', json={'plantId': plantId})
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    return result['code'] == 'SUCCESS'

def exchangeGel(plantId):
    r = s.get(baseUrl+'/plant/exchangeGel?plantId={}'.format(plantId))
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)

def warehouse():
    r = s.get(baseUrl+'/plant/warehouse')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    data = result.get('data')
    if data:
        company = data.get('company')
        if company:
            finished = company.get('FINISHED')
            if finished:
                for plant in finished:
                    exchangeGel(plant['plantId'])

def getSeed(saleId):
    r = s.post(baseUrl+'/seed/buy', json={'saleId': saleId})
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return False
    result = r.json()
    logging.info(result)
    return result['code'] == 'SUCCESS'

def shake():
    r = s.post(baseUrl+'/plant/shake')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return None
    result = r.json()
    logging.info(result)
    if result['code'] == 'SUCCESS':
        return result['data']['plantDefineId']

def plantConfirm(plantDefineId):
    r = s.post(baseUrl+'/plant/confirm', json={'plantDefineId': plantDefineId, 'location': 'company'})
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return False
    result = r.json()
    logging.info(result)
    return result['code'] == 'SUCCESS'

def seedActions():
    r = s.get(baseUrl+'/seed/getSaleInfo')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    if result['code'] == 'SUCCESS':
        saleId = result['data']['saleId']
        if getSeed(saleId):
            plantDefineId = shake()
            if plantDefineId and plantConfirm(plantDefineId):
                time.sleep(5)
                plantActions()

def plantActions():
    r = s.get(baseUrl+'/plant/get')
    if (r.status_code != 200):
        logging.error("http error: %d", r.status_code)
        return
    result = r.json()
    logging.info(result)
    data = result.get('data')
    if data:
        plantId = data['plantId']
        status = data['status']
        if status == 'GROWING':
            currentEnergy = data['currentEnergy']
            needEnergy = data['needEnergy']
            if currentEnergy >= needEnergy:
                if grownup(plantId):
                    exchangeGel(plantId)
            else:
                fertilize(plantId)
        elif status == 'FINISHED':
            exchangeGel(plantId)
        else:
            seedActions()
    else:
        seedActions()
    warehouse()


uploadSteps()
sign()
#  clickBubbles()
#  plantActions()

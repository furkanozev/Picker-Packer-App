from unicode_tr import unicode_tr
from unidecode import unidecode
import hashlib
from sqlalchemy.sql.expression import false, table, true
from sqlalchemy.sql.schema import MetaData
from config import Config
from flask import Flask, request, jsonify
from sqlalchemy import func, create_engine, Table, or_
from sqlalchemy.orm import Session
from sqlalchemy.ext.automap import automap_base
from datetime import datetime
import requests

app = Flask(__name__)

engine = create_engine(Config.DB_URI)
Base = automap_base()
Base.prepare(engine, reflect=True)

Accounts = Base.classes.account
PickerUser = Base.classes.picker_user
PackerUser = Base.classes.packer_user
Category = Base.classes.category
Item = Base.classes.item
PickerOrders = Base.classes.pickerorders
PickerOrderItems = Base.classes.pickerorderitems
PackerOrders = Base.classes.packerorders
PackerOrderItems = Base.classes.packerorderitems
Carts = Base.classes.carts

session = Session(engine)
metadata = MetaData(engine)

# !
@app.route('/register', methods=['POST'])
def register():
    try:
        req = request.json
        account = Table('account', metadata, autoload=True)
        password = hashlib.sha256(req['password'].encode()).hexdigest()

        req['name'] = unicode_tr(req['name']).title()
        req['email'] = unidecode(req['email'].lower())

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if 'photo' in req:
            engine.execute(account.insert(), name=req['name'], email=req['email'],
                        password=password, phone=req['phone'], age=req['age'], mode=req['mode'],
                        create_date=date_time, update_date=date_time, last_login_date=date_time, photo=req['photo'])

        else:
            engine.execute(account.insert(), name=req['name'], email=req['email'],
                        password=password, phone=req['phone'], age=req['age'], mode=req['mode'],
                        create_date=date_time, update_date=date_time, last_login_date=date_time)

    except Exception as err:
        return jsonify({'result': False})

    try:
        picker_user = Table('picker_user', metadata, autoload=True)
        packer_user = Table('packer_user', metadata, autoload=True)
        user_session = session.query(Accounts).filter(Accounts.email == req['email'])
        user = user_session.first()

        if req['mode'] != 1 and req['mode'] != 2 and req['mode'] != 3:
            raise Exception

        if req['mode'] == 1 or req['mode'] == 3:
            engine.execute(picker_user.insert(), account_id=user.account_id)

        if req['mode'] == 2 or req['mode'] == 3:
            engine.execute(packer_user.insert(), account_id=user.account_id)

    except Exception as err:
        if user is not None:
            user_session.delete()
            session.commit()

        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/login', methods=['POST'])
def login():
    try:
        req = request.json
        account = Table('account', metadata, autoload=True)

        req['username'] = unidecode(req['username'].lower())

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")
        
        user_obj = session.query(Accounts).filter(Accounts.email == req['username'], Accounts.password == req['password'], Accounts.is_active == True)

        user = user_obj.first()

        if user is not None:
            user_obj.update({'last_login_date':  date_time})
            session.commit()

        else:
            user_obj = session.query(Accounts).filter(Accounts.phone == req['username'], Accounts.password == req['password'], Accounts.is_active == True)

            user = user_obj.first()

            if user is not None:
                user_obj.update({'last_login_date':  date_time})
                session.commit()
    
    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    if user is None:
        return jsonify({'result': False})
    else:
        return jsonify({'result': True,
                        'response':{'account_id': user.account_id, 'mode': user.mode}})

@app.route('/getPickerProfile', methods=['POST'])
def getPickerProfile():
    try:
        req = request.json

        user = session.query(Accounts).filter(Accounts.account_id == req['account_id']).first()
        
        user_info = session.query(PickerUser).filter(PickerUser.account_id == req['account_id']).first()
        is_active = user_info.picker_active
        
        if user.photo is not None:
            photo = user.photo.decode()
        else:
            photo = user.photo

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response':{'name': user.name, 'email': user.email, 
                    'phone': user.phone, 'age': user.age, 'photo': photo, 
                    'is_active': is_active}})

@app.route('/setPickerPhoto', methods=['POST'])
def setPickerPhoto():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if req['photo'] is None:
            photo = None
        else:
            photo = req['photo'].encode()

        session.query(Accounts).filter(Accounts.account_id == req['account_id']).update({'photo': photo, 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPackerPhoto', methods=['POST'])
def setPackerPhoto():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if req['photo'] is None:
            photo = None
        else:
            photo = req['photo'].encode()

        session.query(Accounts).filter(Accounts.account_id == req['account_id']).update({'photo': photo, 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/getPackerProfile', methods=['POST'])
def getPackerProfile():
    try:
        req = request.json

        user = session.query(Accounts).filter(Accounts.account_id == req['account_id']).first()
        
        user_info = session.query(PackerUser).filter(PackerUser.account_id == req['account_id']).first()
        is_active = user_info.packer_active
        
        if user.photo is not None:
            photo = user.photo.decode()
        else:
            photo = user.photo

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response':{'name': user.name, 'email': user.email, 
                    'phone': user.phone, 'age': user.age, 'photo': photo, 
                    'is_active': is_active}})

@app.route('/setPickerProfile', methods=['POST'])
def setPickerProfile():
    try:
        req = request.json
        req['name'] = unicode_tr(req['name']).title()
        req['email'] = unidecode(req['email'].lower())

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")
        
        user =  session.query(Accounts).filter(Accounts.account_id == req['account_id']).update({'name':  req['name'], 
                                'email': req['email'], 'age': req['age'], 'phone': req['phone'], 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPackerProfile', methods=['POST'])
def setPackerProfile():
    try:
        req = request.json
        req['name'] = unicode_tr(req['name']).title()
        req['email'] = unidecode(req['email'].lower())

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")
        
        user =  session.query(Accounts).filter(Accounts.account_id == req['account_id']).update({'name':  req['name'], 
                                'email': req['email'], 'age': req['age'], 'phone': req['phone'], 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPickerPassword', methods=['POST'])
def setPickerPassword():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")
        
        user_session =  session.query(Accounts).filter(Accounts.account_id == req['account_id'], Accounts.password == req['currentPassword'])
        user = user_session.first()
        
        if user is None:
            raise Exception

        user_session.update({'password': req['newPassword'], 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPackerPassword', methods=['POST'])
def setPackerPassword():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")
        
        user_session =  session.query(Accounts).filter(Accounts.account_id == req['account_id'], Accounts.password == req['currentPassword'])
        user = user_session.first()

        if user is None:
            raise Exception

        user_session.update({'password': req['newPassword'], 'update_date': date_time})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPickerActive', methods=['POST'])
def setPickerActive():
    try:
        req = request.json

        user_session =  session.query(PickerUser).filter(PickerUser.account_id == req['account_id'])
        user = user_session.first()

        if user is None:
            raise Exception
        
        user_session.update({'picker_active':  req['picker_active']})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/setPackerActive', methods=['POST'])
def setPackerActive():
    try:
        req = request.json

        user_session =  session.query(PackerUser).filter(PackerUser.account_id == req['account_id'])
        user = user_session.first()

        if user is None:
            raise Exception
        
        user_session.update({'packer_active':  req['packer_active']})
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/addCategory', methods=['POST'])
def addCategory():
    try:
        category = Table('category', metadata, autoload=True)

        req = request.json
        req['category'] = unicode_tr(req['category']).title()

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if req['category'] == 'Diğer':
            raise Exception

        engine.execute(category.insert(), category=req['category'], subcategory='Diğer', 
                        is_cold=req['is_cold'], create_date = date_time, update_date = date_time)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/updateCategory', methods=['POST'])
def updateCategory():
    try:
        req = request.json
        req['category'] = unicode_tr(req['category']).title()

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if req['category'] == 'Diğer':
            raise Exception

        if 'newcold' not in req and 'newcategory' not in req:
            raise Exception

        category_session = session.query(Category).filter(Category.category == req['category'])

        if 'newcold' in req:
            category_session.update({'is_cold':  req['newcold'], 'update_date':  date_time})

        if 'newcategory' in req:
            req['newcategory'] = unicode_tr(req['newcategory']).title()
            category_session.update({'category':  req['newcategory'], 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/getCategory', methods=['POST'])
def getCategory():
    try:
        req = request.json
        
        category = session.query(Category).filter(Category.category_id == req['category_id']).first()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 
                    'response':{'category': category.category, 'subcategory': category.subcategory,
                                'is_cold': category.is_cold}})

def getCategoryFunc(category_id):
    try:
        category = session.query(Category).filter(Category.category_id == category_id).first()

    except Exception as err:
        session.rollback()
        return {'result': False}

    return {'result': True, 'response':{'category': category.category, 
            'subcategory': category.subcategory, 'is_cold': category.is_cold}}

# !
@app.route('/addSubcategory', methods=['POST'])
def addSubcategory():
    try:
        category = Table('category', metadata, autoload=True)

        req = request.json
        req['category'] = unicode_tr(req['category']).title()
        req['subcategory'] = unicode_tr(req['subcategory']).title()

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        if req['category'] == 'Diğer' or req['subcategory'] == 'Diğer':
            raise Exception

        if session.query(Category).filter(Category.category == req['category']).count() == 0:
            raise Exception

        engine.execute(category.insert(), category=req['category'], subcategory=req['subcategory'], 
                        is_cold=req['is_cold'], create_date = date_time, update_date = date_time)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/updateSubcategory', methods=['POST'])
def updateSubcategory():
    try:
        req = request.json
        req['category'] = unicode_tr(req['category']).title()
        req['subcategory'] = unicode_tr(req['subcategory']).title()

        if req['category'] == 'Diğer' or req['subcategory'] == 'Diğer':
            raise Exception

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        category_session = session.query(Category).filter(Category.category == req['category'], Category.subcategory == req['subcategory'])

        if 'newcold' not in req and 'newcategory' not in req:
            raise Exception

        if 'newcold' in req:
            category_session.update({'is_cold':  req['newcold'], 'update_date':  date_time})

        if 'newsubcategory' in req:
            if req['newsubcategory'] == 'Diğer':
                raise Exception

            req['newsubcategory'] = unicode_tr(req['newsubcategory']).title()

            category_session.update({'subcategory':  req['newsubcategory'], 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/addCart', methods=['POST'])
def addCart():
    try:
        cart = Table('carts', metadata, autoload=True)

        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        engine.execute(cart.insert(), barcode=req['barcode'], create_date = date_time)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/addItem', methods=['POST'])
def addItem():
    try:
        item = Table('item', metadata, autoload=True)

        req = request.json
        req['name'] = unicode_tr(req['name']).title()

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        engine.execute(item.insert(), name=req['name'], category_id=req['category_id'], price=round(req['price'], 2), barcode=req['barcode'], 
                        create_date = date_time, update_date = date_time)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/updateItem', methods=['POST'])
def updateItem():
    try:
        req = request.json
        req['name'] = unicode_tr(req['name']).title()

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        item_session = session.query(Item).filter(Item.name == req['name'])

        if 'newprice' not in req and 'newbarcode' not in req and 'newname' not in req:
            raise Exception

        if 'newprice' in req:
            item_session.update({'price':  round(req['newprice'], 2), 'update_date':  date_time})

        if 'newbarcode' in req:
            item_session.update({'barcode':  req['newbarcode'], 'update_date':  date_time})
            
        if 'newname' in req:
            req['newname'] = unicode_tr(req['newname']).title()
            item_session.update({'name':  req['newname'], 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/getItem', methods=['POST'])
def getItem():
    try:
        req = request.json

        if 'item_id' not in req and 'name' not in req:
            raise Exception

        if 'item_id' in req:
            items = session.query(Item).filter(Item.item_id == req['item_id']).first()

        if 'name' in req:
            req['name'] = unicode_tr(req['name']).title()
            items = session.query(Item).filter(Item.name == req['name']).first()

        category = getCategoryFunc(items.category_id)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    if items is None or category['result'] == False:
        return jsonify({'result': False})
    else:
        res = {'item_id': items.item_id, 'name': items.name, 'price': round(items.price, 2), 'barcode': items.barcode}
        res.update(category['response'])

        return jsonify({'result': True, 'response': res})

def getItemFunc(name):
    try:
        items = session.query(Item).filter(Item.name == name).first()

        category = getCategoryFunc(items.category_id)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    if items is None or category['result'] == False:
        return {'result': False}
    else:
        res = {'item_id': items.item_id, 'name': items.name, 'price': round(items.price, 2), 'barcode': items.barcode}
        res.update(category['response'])

        return {'result': True, 'response': res}

def getItemFuncID(item_id):
    try:
        items = session.query(Item).filter(Item.item_id == item_id).first()

        category = getCategoryFunc(items.category_id)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    if items is None or category['result'] == False:
        return {'result': False}
    else:
        res = {'item_id': items.item_id, 'name': items.name, 'price': round(items.price, 2), 'barcode': items.barcode}
        res.update(category['response'])

        return {'result': True, 'response': res}
    
# !
@app.route('/addPickerOrder', methods=['POST'])
def addPickerOrder():
    try:
        pickerorders = Table('pickerorders', metadata, autoload=True)
        pickerorderitems = Table('pickerorderitems', metadata, autoload=True)

        req = request.json
        req['name'] = unicode_tr(req['name']).title()
        req['address'] = unicode_tr(req['address'])

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        item_list = list()
        price = 0
        item_amount = 0

        for itemx in req['items']:
            itemx['name'] = unicode_tr(itemx['name']).title()
            item_info = getItemFunc(itemx['name'])
            item_info = item_info['response']
            item_info['amount'] = itemx['amount']
            item_list.append(item_info)
            price += item_info['price'] * itemx['amount']
            price = round(price, 2)
            item_amount += itemx['amount']

        if 'account_id' in req:
            account_id = req['account_id']
            picker_user = session.query(PickerUser).filter(PickerUser.account_id == account_id, PickerUser.picker_active == True).first()
            if picker_user is None:
                raise Exception
                
            engine.execute(pickerorders.insert(), account_id = account_id, name = req['name'], note = req['note'], 
                            phone=req['phone'], date=req['date'], address=req['address'], price = price, last_price = price, 
                            item_amount = item_amount, create_date = date_time, update_date = date_time)

        else:
            picker_user_min = session.query(func.min(PickerUser.open_order)).filter(PickerUser.picker_active == True).scalar()
            picker_user = session.query(PickerUser).filter(PickerUser.open_order == picker_user_min, PickerUser.picker_active == True).first()
            account_id = picker_user.account_id
            
            engine.execute(pickerorders.insert(), account_id = account_id, name = req['name'], note = req['note'], 
                            phone=req['phone'], date=req['date'], address=req['address'], price = price, last_price = price, 
                            item_amount = item_amount, create_date = date_time, update_date = date_time)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    try:
        order_session = session.query(PickerOrders).filter(PickerOrders.phone == req['phone'], PickerOrders.date == req['date'],  
                                                    PickerOrders.create_date == date_time)
        order = order_session.first()

        for itemx in item_list:
            engine.execute(pickerorderitems.insert(), order_id = order.order_id, item_id = itemx['item_id'], amount = itemx['amount'])
            
    except Exception as err:
        if order is not None:
            order_session.delete()
            session.commit()
        else:
            session.rollback()
        return jsonify({'result': False})

    try:
        picker_user_session = session.query(PickerUser).filter(PickerUser.account_id == account_id)
        picker_user = picker_user_session.first()
        picker_user_session.update({'open_order': picker_user.open_order + 1})
        session.commit()
    
    except Exception as err:
        if order is not None:
            session.query(PickerOrderItems).filter(PickerOrderItems.order_id == order.order_id).delete()
            order_session.delete()
            session.commit()
        else:
            session.rollback()
        
        return jsonify({'result': False})
        
    return jsonify({'result': True})

# !
@app.route('/getPickerOrder', methods=['POST'])
def getPickerOrder():
    try:
        req = request.json
        picker_orders = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], 
                        PickerOrders.status == 0, PickerOrders.cart_id.is_(None)).all()

        response = list()

        for index_order in picker_orders:
            order = {'order_id': index_order.order_id, 'date': index_order.date, 'item_amount': index_order.item_amount, 
                        'name': index_order.name, 'note': index_order.note, 'phone': index_order.phone}

            response.append(order)

        response.sort(key=lambda x: x['date'].split('.'))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/getPickerOrderItems', methods=['POST'])
def getPickerOrderItems():
    try:
        req = request.json
        order_items = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id']).all()

        response = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold}
            response.append(item_list)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPickerOrderHistory', methods=['POST'])
def getPickerOrderHistory():
    try:
        req = request.json
        picker_orders = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], 
                        PickerOrders.status != 0, PickerOrders.is_visible == True).all()
        
        response = list()

        for index_order in picker_orders:
            if index_order.status == 1:
                status = 'Completed'
            elif index_order.status == 2:
                status = 'Canceled'
            else:
                status = 'Unknown'

            price_distance = index_order.price - index_order.last_price
            price_distance = round(price_distance, 2)
            
            order = {'order_id': index_order.order_id, 'date': index_order.date, 'item_amount': index_order.item_amount, 
                        'name': index_order.name, 'status': status, 'note': index_order.note, 
                        'phone': index_order.phone, 'update_date': index_order.update_date, 'price_distance': price_distance}

            response.append(order)

        response.sort(key=lambda x: x['update_date'].split('.'), reverse=True)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/getPickerOrderHistoryItems', methods=['POST'])
def getPickerOrderHistoryItems():
    try:
        req = request.json
        order_items = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id']).all()

        response = list()
        response2 = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold, 
                        'is_added': index_order_items.is_added, 'is_deleted': index_order_items.is_deleted,'id': index_order_items.id, 'alternative': index_order_items.alternative}

            if index_order_items.alternative is None:
                response.append(item_list)
            else:
                response2.append(item_list)

        response.sort(key=lambda x: (not x['is_deleted'], x['is_added'], x['id']))

        for index_order_items in response2:
            for i in range(len(response)):
                if index_order_items['alternative'] == response[i]['id']:
                    response.insert(i+1, index_order_items)   

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/update_countPickerOrder', methods=['POST'])
def update_countPickerOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        open_order = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], PickerOrders.status == 0).count()
        complete_order = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], PickerOrders.status == 1).count()
        cancel_order = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], PickerOrders.status == 2).count()
        response = {'open_order': open_order, 'complete_order': complete_order, 'cancel_order': cancel_order}

        picker_user_session = session.query(PickerUser).filter(PickerUser.account_id == req['account_id']).update({'open_order': open_order, 'complete_order': complete_order, 'cancel_order': cancel_order})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/countPickerOrder', methods=['POST'])
def countPickerOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_user = session.query(PickerUser).filter(PickerUser.account_id == req['account_id']).first()
        response = {'open_order': picker_user.open_order, 'complete_order': picker_user.complete_order, 'cancel_order': picker_user.cancel_order}

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/PickerOrderHistoryDelete', methods=['POST'])
def PickerOrderHistoryDelete():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'], PickerOrders.status != 0)

        picker_order_session.update({'is_visible':  False, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PickerOrderHistoryDeleteAll', methods=['POST'])
def PickerOrderHistoryDeleteAll():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_session = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], 
                                PickerOrders.status != 0, PickerOrders.is_visible == True)

        picker_order_session.update({'is_visible':  False, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PickerOrderScanCartBarcode', methods=['POST'])
def PickerOrderScanCartBarcode():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        cart = session.query(Carts).filter(Carts.barcode == req['barcode']).first()
        if cart is None:
            raise Exception

        packer_orders = session.query(PackerOrders).filter(PackerOrders.cart_id == cart.cart_id).first()
        if packer_orders is not None:
            raise Exception

        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'])

        picker_order_session.update({'cart_id':  cart.cart_id, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PickerOrderCancel', methods=['POST'])
def PickerOrderCancel():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'], PickerOrders.status == 0)
        order = order_session.first()

        picker_user_session = session.query(PickerUser).filter(PickerUser.account_id == order.account_id)
        picker_user = picker_user_session.first()
        picker_user_session.update({'open_order': picker_user.open_order - 1, 'cancel_order': picker_user.cancel_order + 1})

        order_session.update({'status': 2, 'update_date': date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/addPackerOrder', methods=['POST'])
def addPackerOrder():
    try:
        packerorders = Table('packerorders', metadata, autoload=True)
        packerorderitems = Table('packerorderitems', metadata, autoload=True)

        req = request.json
        req['name'] = unicode_tr(req['name']).title()
        req['address'] = unicode_tr(req['address'])

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        item_list = list()
        price = 0
        item_amount = 0
        cold_chain = False

        for itemx in req['items']:
            itemx['name'] = unicode_tr(itemx['name']).title()
            item_info = getItemFunc(itemx['name'])
            item_info = item_info['response']
            cold_chain = cold_chain or item_info['is_cold']
            item_info['amount'] = itemx['amount']
            item_list.append(item_info)
            price += item_info['price'] * itemx['amount']
            price = round(price, 2)
            item_amount += itemx['amount']

        if cold_chain == False:
            is_collected = True
        else:
            is_collected = False

        if 'account_id' in req:
            account_id = req['account_id']
            packer_user = session.query(PackerUser).filter(PackerUser.account_id == account_id, PackerUser.packer_active == True).first()
            if packer_user is None:
                raise Exception
                
            engine.execute(packerorders.insert(), account_id = account_id, name = req['name'], note = req['note'], address=req['address'],
                            phone=req['phone'], date=req['date'], cart_id=req['cart_id'], price = price, last_price = price, cold_chain = cold_chain,
                            is_collected = is_collected, item_amount = item_amount, create_date = date_time, update_date = date_time)

        else:
            packer_user_min = session.query(func.min(PackerUser.open_order)).filter(PackerUser.packer_active == True).scalar()
            packer_user = session.query(PackerUser).filter(PackerUser.open_order == packer_user_min, PackerUser.packer_active == True).first()
            account_id = packer_user.account_id
            
            engine.execute(packerorders.insert(), account_id = account_id, name = req['name'], note = req['note'], address=req['address'],
                            phone=req['phone'], date=req['date'], cart_id=req['cart_id'], price = price, last_price = price, cold_chain = cold_chain, 
                            is_collected = is_collected, item_amount = item_amount, create_date = date_time, update_date = date_time)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    try:
        order_session = session.query(PackerOrders).filter(PackerOrders.phone == req['phone'], PackerOrders.date == req['date'],  
                                                    PackerOrders.create_date == date_time)
        order = order_session.first()

        for itemx in item_list:
            engine.execute(packerorderitems.insert(), order_id = order.order_id, item_id = itemx['item_id'], amount = itemx['amount'])
            
    except Exception as err:
        if order is not None:
            order_session.delete()
            session.commit()
        else:
            session.rollback()

        return jsonify({'result': False})

    try:
        packer_user_session = session.query(PackerUser).filter(PackerUser.account_id == account_id)
        packer_user = packer_user_session.first()
        packer_user_session.update({'open_order': packer_user.open_order + 1})
        session.commit()
    
    except Exception as err:
        if order is not None:
            session.query(PackerOrderItems).filter(PackerOrderItems.order_id == order.order_id).delete()
            order_session.delete()
            session.commit()
        else:
            session.rollback()
        
        return jsonify({'result': False})
        
    return jsonify({'result': True})

# !
@app.route('/getPackerOrder', methods=['POST'])
def getPackerOrder():
    try:
        req = request.json
        packer_orders = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], 
                        PackerOrders.status == 0, PackerOrders.is_prepare == False).all()

        response = list()

        for index_order in packer_orders:
            cart = session.query(Carts).filter(Carts.cart_id == index_order.cart_id).first()
            price_distance = index_order.price - index_order.last_price
            price_distance = round(price_distance, 2)
            order = {'order_id': index_order.order_id, 'cart_barcode': cart.barcode, 'date': index_order.date, 'cold_chain': index_order.cold_chain, 
                        'is_collected': index_order.is_collected, 'item_amount': index_order.item_amount, 'name': index_order.name, 'note': index_order.note, 
                        'phone': index_order.phone, 'address': index_order.address, 'price_distance': price_distance}

            response.append(order)

        response.sort(key=lambda x: x['date'].split('.'))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/getPackerOrderItems', methods=['POST'])
def getPackerOrderItems():
    try:
        req = request.json
        order_items = session.query(PackerOrderItems).filter(PackerOrderItems.order_id == req['order_id']).all()

        response = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold, 
                            'is_deleted': index_order_items.is_deleted, 'is_added': index_order_items.is_added, 'price': round(item_type.price, 2)}
            response.append(item_list)

        response.sort(key=lambda x: (x['is_deleted'], x['is_added']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPackerOrderHistory', methods=['POST'])
def getPackerOrderHistory():
    try:
        req = request.json
        packer_orders = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], 
                        PackerOrders.status != 0, PackerOrders.is_visible == True).all()
        
        response = list()

        for index_order in packer_orders:
            if index_order.status == 1:
                status = 'Completed'
            elif index_order.status == 2:
                status = 'Canceled'
            else:
                status = 'Unknown'

            price_distance = index_order.price - index_order.last_price
            price_distance = round(price_distance, 2)
            order = {'order_id': index_order.order_id, 'date': index_order.date, 'item_amount': index_order.item_amount, 
                        'name': index_order.name, 'status': status, 'note': index_order.note, 'phone': index_order.phone, 
                        'address': index_order.address, 'price_distance': price_distance, 'update_date': index_order.update_date}

            response.append(order)

        response.sort(key=lambda x: x['update_date'].split('.'), reverse=True)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/getPackerOrderHistoryItems', methods=['POST'])
def getPackerOrderHistoryItems():
    try:
        req = request.json
        order_items = session.query(PackerOrderItems).filter(PackerOrderItems.order_id == req['order_id']).all()

        response = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold, 
                        'is_added': index_order_items.is_added, 'is_deleted': index_order_items.is_deleted}
            response.append(item_list)

        response.sort(key=lambda x: (x['is_deleted'], x['is_added']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/update_countPackerOrder', methods=['POST'])
def update_countPackerOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        open_order = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], PackerOrders.status == 0).count()
        complete_order = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], PackerOrders.status == 1).count()
        cancel_order = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], PackerOrders.status == 2).count()
        response = {'open_order': open_order, 'complete_order': complete_order, 'cancel_order': cancel_order}

        packer_user_session = session.query(PackerUser).filter(PackerUser.account_id == req['account_id']).update({'open_order': open_order, 'complete_order': complete_order, 'cancel_order': cancel_order})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/countPackerOrder', methods=['POST'])
def countPackerOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        packer_user = session.query(PackerUser).filter(PackerUser.account_id == req['account_id']).first()
        response = {'open_order': packer_user.open_order, 'complete_order': packer_user.complete_order, 'cancel_order': packer_user.cancel_order}

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/PackerOrderHistoryDelete', methods=['POST'])
def PackerOrderHistoryDelete():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        packer_order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'], PackerOrders.status != 0)

        packer_order_session.update({'is_visible':  False, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PackerOrderHistoryDeleteAll', methods=['POST'])
def PackerOrderHistoryDeleteAll():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        packer_order_session = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], 
                                PackerOrders.status != 0, PackerOrders.is_visible == True)

        packer_order_session.update({'is_visible':  False, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PackerOrderScanCartBarcode', methods=['POST'])
def PackerOrderScanCartBarcode():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        cart = session.query(Carts).filter(Carts.barcode == req['barcode']).first()

        if cart is None:
            raise Exception

        packer_order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'], PackerOrders.cart_id == cart.cart_id)

        if packer_order_session.first() is None:
            raise Exception

        packer_order_session.update({'is_prepare':  True, 'update_date':  date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PackerOrderCancel', methods=['POST'])
def PackerOrderCancel():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'], PackerOrders.status == 0)
        order = order_session.first()

        packer_user_session = session.query(PackerUser).filter(PackerUser.account_id == order.account_id)
        packer_user = packer_user_session.first()
        packer_user_session.update({'open_order': packer_user.open_order - 1, 'cancel_order': packer_user.cancel_order + 1})

        order_session.update({'status': 2, 'is_collected': False, 'cart_id': None, 'update_date': date_time})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/PackerOrderCollectColdChain', methods=['POST'])
def PackerOrderCollectColdChain():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id']).update({'is_collected': True})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/getItems', methods=['POST'])
def getItems():
    try:
        req = request.json
        items = session.query(Item).all()

        response = list()

        for index_items in items:
            category_type = session.query(Category).filter(Category.category_id == index_items.category_id).first()

            item_list = {'item_id': index_items.item_id, 'name': index_items.name, 'price': round(index_items.price, 2), 'category': category_type.category, 'subcategory': category_type.subcategory}
            response.append(item_list)

        response.sort(key=lambda x: (x['category'], x['subcategory'], x['name']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/addItemOrder', methods=['POST'])
def addItemOrder():
    try:
        pickerorderitems = Table('pickerorderitems', metadata, autoload=True)

        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_items_session = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.item_id == req['item_id'], PickerOrderItems.is_added == True)
        picker_order_item = picker_order_items_session.first()

        if picker_order_item is None:
            engine.execute(pickerorderitems.insert(), order_id = req['order_id'], item_id = req['item_id'], is_added = True, amount = 1)

        else:
            picker_order_items_session.update({'amount': picker_order_item.amount + 1})
            session.commit()

    except Exception as err:
        if picker_order_item is None:
            session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.item_id == req['item_id'], PickerOrderItems.is_added == True).delete()
            session.commit()
        else:
            session.rollback()

        return jsonify({'result': False})

    try:
        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'])
        picker_order = picker_order_session.first()

        if picker_order is None:
            raise Exception

        item = session.query(Item).filter(Item.item_id == req['item_id']).first()
        if item is None:
            raise Exception

        picker_order_session.update({'last_price': round(picker_order.last_price + item.price, 2), 'item_amount': picker_order.item_amount + 1 ,'update_date': date_time})
        session.commit()

    except Exception as err:
        if picker_order_item is None:
            session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.item_id == req['item_id'], PickerOrderItems.is_added == True).delete()
            session.commit()
        else:
            session.rollback()

        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/deletePickerItemOrder', methods=['POST'])
def deletePickerItemOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_items_session = session.query(PickerOrderItems).filter(PickerOrderItems.id == req['id'])
        picker_order_item = picker_order_items_session.first()
        if picker_order_item is None:
            raise Exception

        item = session.query(Item).filter(Item.item_id == picker_order_item.item_id).first()
        if item is None:
            raise Exception

        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == picker_order_item.order_id)
        picker_order = picker_order_session.first()
        if picker_order is None:
            raise Exception

        if picker_order_item.is_deleted == True:
            raise Exception

        if picker_order_item.is_added == False:
            price = item.price * picker_order_item.amount
            picker_order_items_session.update({'is_deleted': True, 'cart_amount': 0})
            picker_order_session.update({'last_price': round(picker_order.last_price - price, 2), 'item_amount': picker_order.item_amount - picker_order_item.amount, 'update_date': date_time})
            session.commit()

        else:
            if picker_order_item.amount > 1:
                if picker_order_item.amount <= picker_order_item.cart_amount:
                    cart_amount = picker_order_item.amount - 1

                else:
                    cart_amount = picker_order_item.cart_amount

                picker_order_items_session.update({'amount': picker_order_item.amount - 1, 'cart_amount': cart_amount})
                    
                picker_order_session.update({'last_price': round(picker_order.last_price - item.price, 2), 'item_amount': picker_order.item_amount - 1, 'update_date': date_time})
                session.commit()
            else:
                picker_order_session.update({'last_price': round(picker_order.last_price - item.price, 2), 'item_amount': picker_order.item_amount - 1, 'update_date': date_time})
                picker_order_items_session.delete()
                session.commit()

    except Exception as err:
        return jsonify({'result': False})
    
    return jsonify({'result': True})

# !
@app.route('/getPickerOrderPrepare', methods=['POST'])
def getPickerOrderPrepare():
    try:
        req = request.json
        picker_orders = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], 
                        PickerOrders.status == 0, PickerOrders.cart_id.is_not(None)).all()

        response = list()

        for index_order in picker_orders:
            cart = session.query(Carts).filter(Carts.cart_id == index_order.cart_id).first()
            order = {'order_id': index_order.order_id, 'date': index_order.date, 'item_amount': index_order.item_amount, 
                        'name': index_order.name, 'note': index_order.note, 'phone': index_order.phone, 'cart_barcode': cart.barcode}

            response.append(order)

        response.sort(key=lambda x: x['date'].split('.'))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/getPickerOrderPrepareItems', methods=['POST'])
def getPickerOrderPrepareItems():
    try:
        req = request.json

        order_items = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id']).all()

        item_list_response = list()
        item_list_response2 = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            if index_order_items.cart_amount >= index_order_items.amount:
                is_cart = True
            else:
                is_cart = False

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold, 
                        'price': round(item_type.price, 2), 'category': category_type.category, 'subcategory': category_type.subcategory, 
                        'is_added': index_order_items.is_added, 'is_deleted': index_order_items.is_deleted, 'is_cart': is_cart,
                        'id': index_order_items.id, 'alternative': index_order_items.alternative}

            if index_order_items.alternative is None:
                item_list_response.append(item_list)
            else:
                item_list_response2.append(item_list)

        item_list_response.sort(key=lambda x: (not x['is_deleted'], x['is_added'], x['category'], x['subcategory'], x['id']))

        for index_order_items in item_list_response2:
            for i in range(len(item_list_response)):
                if index_order_items['alternative'] == item_list_response[i]['id']:
                    item_list_response.insert(i+1, index_order_items)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': item_list_response})

@app.route('/getPickerOrderPriceDistance', methods=['POST'])
def getPickerOrderPriceDistance():
    try:
        req = request.json

        picker_order = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id']).first()
        if picker_order is None:
            raise Exception

        price_distance = picker_order.price - picker_order.last_price
        price_distance = round(price_distance, 2)

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': {'price_distance': price_distance}})

# !
@app.route('/getPickerOrderPrepareProcessItems', methods=['POST'])
def getPickerOrderPrepareProcessItems():
    try:
        req = request.json

        picker_orders = session.query(PickerOrders).filter(PickerOrders.account_id == req['account_id'], 
                        PickerOrders.status == 0, PickerOrders.cart_id.is_not(None)).all()

        response = list()

        for index_order in picker_orders:
            order_items = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == index_order.order_id).all()
            cart = session.query(Carts).filter(Carts.cart_id == index_order.cart_id).first()

            for index_order_items in order_items:
                item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
                category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

                amount = index_order_items.amount - index_order_items.cart_amount

                if index_order_items.is_deleted == True or amount <= 0:
                    continue

                item_list = {'name': item_type.name, 'amount': amount, 'is_cold': category_type.is_cold, 'order_id': index_order.order_id,
                            'category': category_type.category, 'subcategory': category_type.subcategory, 'id': index_order_items.id, 
                            'cart_barcode': cart.barcode, 'item_barcode': item_type.barcode, 'item_id': index_order_items.item_id}

                response.append(item_list)

        response.sort(key=lambda x: (x['is_cold'], x['category'], x['subcategory'], x['item_id'], x['order_id']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/PickerCancelPrepare', methods=['POST'])
def PickerCancelPrepare():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'])
        picker_order = picker_order_session.first()

        if picker_order is None or picker_order.cart_id is None:
            raise Exception

        count = session.query(func.sum(PickerOrderItems.amount)).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.is_added == False).scalar()
        session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.is_added == True).delete()
        session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.is_deleted == True).update({'is_deleted': False})
        session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id']).update({'cart_amount': 0})

        picker_order_session.update({'cart_id': None, 'last_price': round(picker_order.price, 2), 'item_amount': count, 'update_date': date_time})
        
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PickerCompleteOrder', methods=['POST'])
def PickerCompleteOrder():
    try:
        packerorders = Table('packerorders', metadata, autoload=True)
        packerorderitems = Table('packerorderitems', metadata, autoload=True)

        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_orders_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'])
        picker_orders = picker_orders_session.first()
        if picker_orders is None or picker_orders.cart_id is None:
            raise Exception

        picker_user_session = session.query(PickerUser).filter(PickerUser.account_id == picker_orders.account_id)
        picker_user = picker_user_session.first()
        if picker_user is None:
            raise Exception

        picker_order_items_session = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'])
        picker_order_items = picker_order_items_session.all()

        if picker_order_items is None:
            raise Exception

        for itemx in picker_order_items:
            if itemx.is_deleted == False and (itemx.amount != itemx.cart_amount):
                raise Exception

        cold_chain = False

        for itemx in picker_order_items:
            item_info = getItemFuncID(itemx.item_id)
            item_info = item_info['response']
            cold_chain = cold_chain or item_info['is_cold']

        if cold_chain == False:
            is_collected = True
        else:
            is_collected = False

        packer_user_min = session.query(func.min(PackerUser.open_order)).filter(PackerUser.packer_active == True).scalar()
        packer_user = session.query(PackerUser).filter(PackerUser.open_order == packer_user_min, PackerUser.packer_active == True).first()
        account_id = packer_user.account_id

        engine.execute(packerorders.insert(), account_id = account_id, name = picker_orders.name, note = picker_orders.note, 
                        address = picker_orders.address, phone = picker_orders.phone, date = picker_orders.date, cart_id = picker_orders.cart_id, 
                        price = round(picker_orders.price, 2), last_price = round(picker_orders.last_price, 2), cold_chain = cold_chain, is_collected = is_collected, 
                        item_amount = picker_orders.item_amount, create_date = date_time, update_date = date_time)

        picker_orders_session.update({'status': 1, 'cart_id': None, 'update_date': date_time})
        picker_user_session.update({'open_order': picker_user.open_order - 1, 'complete_order': picker_user.complete_order + 1})

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    try:
        order_session = session.query(PackerOrders).filter(PackerOrders.phone == picker_orders.phone, PackerOrders.date == picker_orders.date,  
                                                    PackerOrders.create_date == date_time)
        order = order_session.first()

        for itemx in picker_order_items:
            engine.execute(packerorderitems.insert(), order_id = order.order_id, item_id = itemx.item_id, amount = itemx.amount, 
                            is_added = itemx.is_added, is_deleted = itemx.is_deleted)
            
    except Exception as err:
        if order is not None:
            order_session.delete()
            session.commit()
        else:
            session.rollback()

        return jsonify({'result': False})

    try:
        packer_user_session = session.query(PackerUser).filter(PackerUser.account_id == account_id)
        packer_user = packer_user_session.first()
        packer_user_session.update({'open_order': packer_user.open_order + 1})
        session.commit()
    
    except Exception as err:
        if order is not None:
            session.query(PackerOrderItems).filter(PackerOrderItems.order_id == order.order_id).delete()
            order_session.delete()
            session.commit()
        else:
            session.rollback()
        
        return jsonify({'result': False})
        
    return jsonify({'result': True})

@app.route('/PickerOrderScanPrepareCart', methods=['POST'])
def PickerOrderScanPrepareCart():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_items_session = session.query(PickerOrderItems).filter(PickerOrderItems.id == req['id'])
        picker_order_item = picker_order_items_session.first()

        if picker_order_item is None:
            raise Exception

        picker_order_items_session.update({'cart_amount': picker_order_item.cart_amount + 1})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/getPickerCurrentItems', methods=['POST'])
def getPickerCurrentItems():
    try:
        req = request.json

        order_items = session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id']).all()

        item_list_response = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            if index_order_items.cart_amount >= index_order_items.amount:
                is_cart = True
            else:
                is_cart = False

            if index_order_items.is_deleted == True or index_order_items.is_added == True:
                continue

            item_list = {'name': item_type.name, 'price': round(item_type.price, 2), 'category': category_type.category, 
                        'subcategory': category_type.subcategory, 'id': index_order_items.id}
            item_list_response.append(item_list)

        item_list_response.sort(key=lambda x: (x['name'], x['category'], x['subcategory'], x['id']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': item_list_response})

@app.route('/addAlternativeItemOrder', methods=['POST'])
def addAlternativeItemOrder():
    try:
        pickerorderitems = Table('pickerorderitems', metadata, autoload=True)

        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        picker_order_items_session = session.query(PickerOrderItems).filter(PickerOrderItems.id == req['id'], PickerOrderItems.order_id == req['order_id'])
        picker_order_item = picker_order_items_session.first()

        if picker_order_item is None:
            raise Exception

        engine.execute(pickerorderitems.insert(), order_id = req['order_id'], item_id = req['item_id'], is_added = True, amount = picker_order_item.amount, alternative = picker_order_item.id)


    except Exception as err:
        session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.item_id == req['item_id'], PickerOrderItems.is_added == True).delete()
        session.commit()

        return jsonify({'result': False})

    try:
        picker_order_items_session.update({'is_deleted': True, 'cart_amount': 0})
        picker_order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'])
        picker_order = picker_order_session.first()

        if picker_order is None:
            raise Exception

        item = session.query(Item).filter(Item.item_id == req['item_id']).first()
        if item is None:
            raise Exception

        item2 = session.query(Item).filter(Item.item_id == picker_order_item.item_id).first()
        if item2 is None:
            raise Exception

        price = (item.price - item2.price) * picker_order_item.amount

        picker_order_session.update({'last_price': round(picker_order.last_price + price, 2), 'update_date': date_time})
        session.commit()

    except Exception as err:
        if picker_order_item is None:
            session.query(PickerOrderItems).filter(PickerOrderItems.order_id == req['order_id'], PickerOrderItems.item_id == req['item_id'], PickerOrderItems.is_added == True).delete()
            session.commit()
        else:
            session.rollback()

        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PackerCancelDeliver', methods=['POST'])
def PackerCancelDeliver():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        packer_order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'])
        packer_order = packer_order_session.first()

        if packer_order is None or packer_order.cart_id is None:
            raise Exception

        packer_order_session.update({'is_prepare': False, 'is_collected': not packer_order.cold_chain, 'update_date': date_time})
        
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# !
@app.route('/PackerCompleteOrder', methods=['POST'])
def PackerCompleteOrder():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        packer_order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'])
        packer_order = packer_order_session.first()

        if packer_order is None or packer_order.cart_id is None:
            raise Exception

        packer_user_session = session.query(PackerUser).filter(PackerUser.account_id == packer_order.account_id)
        packer_user = packer_user_session.first()

        if packer_user is None:
            raise Exception

        packer_order_session.update({'status': 1, 'cart_id': None, 'update_date': date_time})
        packer_user_session.update({'open_order': packer_user.open_order - 1, 'complete_order': packer_user.complete_order + 1})
        
        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

# ! Google Map api kullanilcak api calismazsa saate gore sirala
@app.route('/getPackerOrderDeliver', methods=['POST'])
def getPackerOrderDeliver():
    try:
        req = request.json
        packer_orders = session.query(PackerOrders).filter(PackerOrders.account_id == req['account_id'], 
                        PackerOrders.status == 0, PackerOrders.cart_id.is_not(None), PackerOrders.is_prepare == True).all()

        response = list()

        for index_order in packer_orders:
            price_distance = index_order.price - index_order.last_price
            price_distance = round(price_distance, 2)
            cart = session.query(Carts).filter(Carts.cart_id == index_order.cart_id).first()
            order = {'order_id': index_order.order_id, 'date': index_order.date, 'item_amount': index_order.item_amount, 
                        'name': index_order.name, 'note': index_order.note, 'phone': index_order.phone, 'cart_barcode': cart.barcode,
                        'distance': '-', 'time': '-', 'guess_distance': '-', 'guess_time': '-', 'price_distance': price_distance, 
                        'address': index_order.address, 'lat': -999.999, 'lng': -999.999, 'order': -1}

            response.append(order)

        response.sort(key=lambda x: x['date'].split('.'))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    try:
        origin = str(req['lat']) + ',' + str(req['lng'])
        destinations = ''

        for dest in response:
            destinations += dest['address'] + '|'

        if destinations != '':
            destinations = destinations[:-1]

        url = "https://maps.googleapis.com/maps/api/distancematrix/json?origins="+origin+"&destinations="+destinations+"&language=tr&region=tr&key="+Config.API_KEY
        payload={}
        headers = {}

        response_distance = requests.request("GET", url, headers=headers, data=payload)
        response_distance = response_distance.json()

        if response_distance['status'] == 'OK':
            for i in range(len(response)):
                if response_distance['rows'][0]['elements'][i]['status'] == 'OK':
                    response[i]['time'] = response_distance['rows'][0]['elements'][i]['duration']['text']
                    response[i]['distance'] = response_distance['rows'][0]['elements'][i]['distance']['text']

    except Exception as err:
        pass

    try:
        origin = str(req['lat']) + ',' + str(req['lng'])
        waypoints = ''

        for dest in response:
            waypoints += dest['address'] + '|'

        if waypoints != '':
            waypoints = waypoints[:-1]

        url = "https://maps.googleapis.com/maps/api/directions/json?origin="+origin+"&destination="+origin+"&language=tr&region=tr&waypoints=optimize:true%7C"+waypoints+"&key="+Config.API_KEY
        payload={}
        headers = {}

        response_routes = requests.request("GET", url, headers=headers, data=payload)
        response_routes = response_routes.json()

        if response_routes['status'] == 'OK':
            waypoint_order = response_routes['routes'][0]['waypoint_order']

            for i in range(len(response)):
                response[i]['order'] = waypoint_order[i]

            response.sort(key=lambda x: (x['order']))

            for i in range(len(response)):
                response[i]['guess_time'] = response_routes['routes'][0]['legs'][i]['duration']['text']
                response[i]['guess_distance'] = response_routes['routes'][0]['legs'][i]['distance']['text']
                response[i]['lat'] = response_routes['routes'][0]['legs'][i]['end_location']['lat']
                response[i]['lng'] = response_routes['routes'][0]['legs'][i]['end_location']['lng']

    except Exception as err:
        pass

    return jsonify({'result': True, 'response': response})

@app.route('/getPackerOrderDeliverItems', methods=['POST'])
def getPackerOrderDeliverItems():
    try:
        req = request.json
        order_items = session.query(PackerOrderItems).filter(PackerOrderItems.order_id == req['order_id']).all()

        response = list()

        for index_order_items in order_items:
            item_type = session.query(Item).filter(Item.item_id == index_order_items.item_id).first()
            category_type = session.query(Category).filter(Category.category_id == item_type.category_id).first()

            item_list = {'name': item_type.name, 'amount': index_order_items.amount, 'is_cold': category_type.is_cold, 
                            'is_deleted': index_order_items.is_deleted, 'is_added': index_order_items.is_added, 'price': round(item_type.price, 2)}
            response.append(item_list)

        response.sort(key=lambda x: (x['is_deleted'], x['is_added']))

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getUsers', methods=['POST'])
def getUsers():
    try:
        req = request.json

        if req is not None:
            if 'mode' in req and 'active' in req:
                user = session.query(Accounts).filter(Accounts.mode == req['mode'], Accounts.is_active == req['active']).all()
            elif 'mode' in req:
                user = session.query(Accounts).filter(Accounts.mode == req['mode']).all()
            elif 'active' in req:
                user = session.query(Accounts).filter(Accounts.is_active == req['active']).all()
        else:
            user = session.query(Accounts).all()

        if user is None:
            raise Exception

        response = list()

        for usr in user:
            if usr.photo is not None:
                photo = usr.photo.decode()
            else:
                photo = usr.photo

            usr_ = {'name': usr.name, 'email': usr.email, 'phone': usr.phone, 'age': usr.age, 
                    'account_id': usr.account_id, 'mode': usr.mode, 'photo': photo, 'create_date': usr.create_date,
                    'update_date': usr.update_date, 'last_login_date': usr.last_login_date, 'is_active': usr.is_active}

            response.append(usr_)

        response.sort(key=lambda x: x['create_date'].split('.'), reverse = True)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getUser', methods=['POST'])
def getUser():
    try:
        req = request.json

        if req is not None:
            if 'email' in req:
                user = session.query(Accounts).filter(Accounts.email == req['email']).first()
            elif 'phone' in req:
                user = session.query(Accounts).filter(Accounts.phone == req['phone']).first()
            elif 'account_id' in req:
                user = session.query(Accounts).filter(Accounts.account_id == req['account_id']).first()
            else:
                raise Exception

        if user is None:
            raise Exception

        if user.photo is not None:
            photo = user.photo.decode()
        else:
            photo = user.photo

        response = {'name': user.name, 'email': user.email, 'phone': user.phone, 'age': user.age, 
                'account_id': user.account_id, 'mode': user.mode, 'photo': photo, 'create_date': user.create_date,
                'update_date': user.update_date, 'last_login_date': user.last_login_date, 'is_active': user.is_active}

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPickers', methods=['POST'])
def getPickers():
    try:
        req = request.json
        if req is not None:
            if 'active' in req:
                pickers = session.query(PickerUser).filter(PickerUser.picker_active == req['active']).all()
        else:
            pickers = session.query(PickerUser).all()

        if pickers is None:
            raise Exception

        response = list()

        for picker in pickers:
            if req is not None:
                if 'active' in req:
                    user = session.query(Accounts).filter(Accounts.account_id == picker.account_id, Accounts.is_active == req['active']).first()
            else:
                user = session.query(Accounts).filter(Accounts.account_id == picker.account_id).first()

            if user is None:
                continue

            if user.photo is not None:
                photo = user.photo.decode()
            else:
                photo = user.photo

            usr_ = {'name': user.name, 'email': user.email, 'phone': user.phone, 'age': user.age, 
                    'account_id': user.account_id, 'mode': user.mode, 'photo': photo, 'create_date': user.create_date,
                    'update_date': user.update_date, 'last_login_date': user.last_login_date, 'is_active': user.is_active, 
                    'picker_active': picker.picker_active, 'open_order': picker.open_order, 'cancel_order': picker.cancel_order, 
                    'complete_order': picker.complete_order}

            response.append(usr_)

        response.sort(key=lambda x: x['create_date'].split('.'), reverse = True)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPicker', methods=['POST'])
def getPicker():
    try:
        req = request.json

        if req is not None:
            if 'email' in req:
                user = session.query(Accounts).filter(Accounts.email == req['email']).first()
            elif 'phone' in req:
                user = session.query(Accounts).filter(Accounts.phone == req['phone']).first()
            elif 'account_id' in req:
                user = session.query(Accounts).filter(Accounts.account_id == req['account_id']).first()
            else:
                raise Exception

        if user is None:
            raise Exception

        picker = session.query(PickerUser).filter(PickerUser.account_id == user.account_id).first()
        if picker is None:
            raise Exception

        if user.photo is not None:
            photo = user.photo.decode()
        else:
            photo = user.photo

        response = {'name': user.name, 'email': user.email, 'phone': user.phone, 'age': user.age, 
                'account_id': user.account_id, 'mode': user.mode, 'photo': photo, 'create_date': user.create_date,
                'update_date': user.update_date, 'last_login_date': user.last_login_date, 'is_active': user.is_active, 
                'picker_active': picker.picker_active, 'open_order': picker.open_order, 'cancel_order': picker.cancel_order, 
                'complete_order': picker.complete_order}

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPackers', methods=['POST'])
def getPackers():
    try:
        req = request.json
        if req is not None:
            if 'active' in req:
                packers = session.query(PackerUser).filter(PackerUser.packer_active == req['active']).all()
        else:
            packers = session.query(PackerUser).all()

        if packers is None:
            raise Exception

        response = list()

        for packer in packers:
            if req is not None:
                if 'active' in req:
                    user = session.query(Accounts).filter(Accounts.account_id == packer.account_id, Accounts.is_active == req['active']).first()
            else:
                user = session.query(Accounts).filter(Accounts.account_id == packer.account_id).first()

            if user is None:
                continue

            if user.photo is not None:
                photo = user.photo.decode()
            else:
                photo = user.photo

            usr_ = {'name': user.name, 'email': user.email, 'phone': user.phone, 'age': user.age, 
                    'account_id': user.account_id, 'mode': user.mode, 'photo': photo, 'create_date': user.create_date,
                    'update_date': user.update_date, 'last_login_date': user.last_login_date, 'is_active': user.is_active, 
                    'packer_active': packer.packer_active, 'open_order': packer.open_order, 'cancel_order': packer.cancel_order, 
                    'complete_order': packer.complete_order}

            response.append(usr_)

        response.sort(key=lambda x: x['create_date'].split('.'), reverse = True)

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

# !
@app.route('/getPacker', methods=['POST'])
def getPacker():
    try:
        req = request.json

        if req is not None:
            if 'email' in req:
                user = session.query(Accounts).filter(Accounts.email == req['email']).first()
            elif 'phone' in req:
                user = session.query(Accounts).filter(Accounts.phone == req['phone']).first()
            elif 'account_id' in req:
                user = session.query(Accounts).filter(Accounts.account_id == req['account_id']).first()
            else:
                raise Exception

        if user is None:
            raise Exception

        packer = session.query(PackerUser).filter(PackerUser.account_id == user.account_id).first()
        if packer is None:
            raise Exception

        if user.photo is not None:
            photo = user.photo.decode()
        else:
            photo = user.photo

        response = {'name': user.name, 'email': user.email, 'phone': user.phone, 'age': user.age, 
                'account_id': user.account_id, 'mode': user.mode, 'photo': photo, 'create_date': user.create_date,
                'update_date': user.update_date, 'last_login_date': user.last_login_date, 'is_active': user.is_active, 
                'packer_active': packer.packer_active, 'open_order': packer.open_order, 'cancel_order': packer.cancel_order, 
                'complete_order': packer.complete_order}

    except Exception as err:
        return jsonify({'result': False})

    return jsonify({'result': True, 'response': response})

@app.route('/changeOrderPicker', methods=['POST'])
def changeOrderPicker():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        order_session = session.query(PickerOrders).filter(PickerOrders.order_id == req['order_id'], PickerOrders.status == 0)
        order = order_session.first()

        if order is None:
            raise Exception

        account_session = session.query(Accounts).filter(Accounts.account_id == req['account_id'], or_(Accounts.mode == 1, Accounts.mode == 3))
        account = account_session.first()

        if account is None:
            raise Exception

        picker_session = session.query(PickerUser).filter(PickerUser.account_id == req['account_id'], PickerUser.picker_active == True)
        picker = picker_session.first()

        if picker is None:
            raise Exception

        old_account_id = order.account_id
        order_session.update({'account_id': req['account_id'], 'update_date': date_time})
        picker_session.update({'open_order': picker.open_order + 1})

        old_picker_session = session.query(PickerUser).filter(PickerUser.account_id == old_account_id)
        old_picker = old_picker_session.first()

        if old_picker is not None:
            old_picker_session.update({'open_order': old_picker.open_order - 1})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/changeOrderPacker', methods=['POST'])
def changeOrderPacker():
    try:
        req = request.json

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        order_session = session.query(PackerOrders).filter(PackerOrders.order_id == req['order_id'], PackerOrders.status == 0)
        order = order_session.first()

        if order is None:
            raise Exception

        account_session = session.query(Accounts).filter(Accounts.account_id == req['account_id'], or_(Accounts.mode == 2, Accounts.mode == 3))
        account = account_session.first()

        if account is None:
            raise Exception

        packer_session = session.query(PackerUser).filter(PackerUser.account_id == req['account_id'], PackerUser.packer_active == True)
        packer = packer_session.first()

        if packer is None:
            raise Exception

        old_account_id = order.account_id
        order_session.update({'account_id': req['account_id'], 'update_date': date_time})
        packer_session.update({'open_order': packer.open_order + 1})

        old_packer_session = session.query(PackerUser).filter(PackerUser.account_id == old_account_id)
        old_packer = old_packer_session.first()

        if old_packer is not None:
            old_packer_session.update({'open_order': old_packer.open_order - 1})

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})

@app.route('/changeModeUser', methods=['POST'])
def changeModeUser():
    try:
        req = request.json

        picker_user = Table('picker_user', metadata, autoload=True)
        packer_user = Table('packer_user', metadata, autoload=True)

        account_session = session.query(Accounts).filter(Accounts.account_id == req['account_id'])
        account = account_session.first()

        if account is None:
            raise Exception

        now = datetime.now()
        date_time = now.strftime("%Y/%m/%d, %H:%M:%S")

        account_session.update({'mode': req['mode'], 'update_date': date_time})

        if req['mode'] == 1 or req['mode'] == 3:
            picker_session = session.query(PickerUser).filter(PickerUser.account_id == req['account_id'], PickerUser.picker_active == True)
            picker = picker_session.first()
            if picker is None:
                engine.execute(picker_user.insert(), account_id=account.account_id)

        if req['mode'] == 2 or req['mode'] == 3:
            packer_session = session.query(PackerUser).filter(PackerUser.account_id == req['account_id'], PackerUser.packer_active == True)
            packer = packer_session.first()
            if packer is None:
                engine.execute(packer_user.insert(), account_id=account.account_id)

        session.commit()

    except Exception as err:
        session.rollback()
        return jsonify({'result': False})

    return jsonify({'result': True})
import React, { useState } from "react";
import { AddShoppingCart } from '@mui/icons-material'
import './style/CardItem.css';
import CustomizedDialogs from "./CustomDialog";
import AddCartDetail from "./AddCartDetail";
import { Link, useNavigate } from "react-router-dom";
interface cart {
    name: '',
    afterDiscountPrice: '',
    beforeDiscountPrice: '',
    isbn: '',
    quantity_current: '',
    quantity: '',
    image: ''
};
const Card = (props: any) => {
    const navigate = useNavigate();
    const [shoppingCart, setShoppingCart] = useState<Partial<cart>>({})
    const [openDialogCart, setOpenDialogCart] = useState(false);
    const priceDiscount = (price: any, percent_discount: any) => {
        const priceAfterDiscount = price - ((price * percent_discount) / 100);
        return priceAfterDiscount;
    }
    return (
        <div className="card-item" title={props.title}>
            <img src={`http://127.0.0.1:5000/get-image/${props.image}`} className="card__img" />
            <div className="card__body">
                <div className="card__title" >
                    <span onClick={() => { navigate(`/shop/${props.tag_label}/${props.tag}`) }}>{props.title}</span>
                </div>
                <div className="priceContainer">
                    <div className="card__price">{props.percent_discount ? (new Intl.NumberFormat().format(priceDiscount(props.price_current, props.percent_discount))) : new Intl.NumberFormat().format(props.price_current)}</div>
                    {props.percent_discount ? <div className="card__discount">{new Intl.NumberFormat().format(props.price_current)}</div> : null}
                </div>
                <div className="cardBtnContainer">
                    <button className="card__btn" onClick={() => setOpenDialogCart(true)}><AddShoppingCart /></button>
                </div>
            </div>
            {props.is_new ? (<div className="circle-notify">
                <span>Mới</span>
            </div>) : null}
            {props.percent_discount ? <div className="discount-notify">
                <span>{props.percent_discount}</span>
            </div> : null}
            <CustomizedDialogs open={openDialogCart}
                isbn={props.isbn}
                image={props.image}
                shoppingCart={shoppingCart}
                quantity_in_stock={props.quantity_in_stock}
                setOpen={setOpenDialogCart}
                handleClick={props.handleClick}
                price_discount={props.percent_discount ? (priceDiscount(props.price_current, props.percent_discount)) : null}
                price_current={props.price_current}
                title={props.title}>
                <AddCartDetail isbn={props.isbn} shoppingCart={shoppingCart} setShoppingCart={setShoppingCart} />
            </CustomizedDialogs>
        </div>
    )
}
export default Card;
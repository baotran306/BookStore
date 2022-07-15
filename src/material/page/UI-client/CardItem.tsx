import React, { useState } from "react";
import { AddShoppingCart } from '@mui/icons-material'
import './style/CardItem.css';
import CustomizedDialogs from "./CustomDialog";
import AddCartDetail from "./AddCartDetail";
import { Link, useNavigate } from "react-router-dom";
const Card = (props: any) => {
    const navigate = useNavigate();
    const [openDialogCart, setOpenDialogCart] = useState(false);
    const priceDiscount = (price: any, percent_discount: any) => {
        const priceAfterDiscount = price - ((price * percent_discount) / 100);
        return new Intl.NumberFormat().format(priceAfterDiscount);
    }
    return (
        <div className="card-item" title={props.title}>
            <img src={props.img} className="card__img" />
            <div className="card__body">
                <div className="card__title" >
                    <span onClick={() => { navigate(`/shop/${props.tag_label}/${props.tag}`) }}>{props.title}</span>
                </div>
                <div className="priceContainer">
                    <div className="card__price">{props.percent_discount ? (priceDiscount(props.price_current, props.percent_discount)) : new Intl.NumberFormat().format(props.price_current)}</div>
                    {props.percent_discount ? <div className="card__discount">{new Intl.NumberFormat().format(props.price_current)}</div> : null}
                </div>
                <div className="cardBtnContainer">
                    <button className="card__btn" onClick={() => setOpenDialogCart(true)}><AddShoppingCart /></button>
                </div>
            </div>
            {props.is_new ? (<div className="circle-notify">
                <span>NEW</span>
            </div>) : null}
            {props.percent_discount ? <div className="discount-notify">
                <span>{props.percent_discount}</span>
            </div> : null}
            <CustomizedDialogs open={openDialogCart}
                setOpen={setOpenDialogCart}
                price_discount={props.percent_discount ? (priceDiscount(props.price_current, props.percent_discount)) : new Intl.NumberFormat().format(props.price_current)}
                price_current={props.percent_discount ? new Intl.NumberFormat().format(props.price_current) : null}
                title={props.title}>
                <AddCartDetail id_product={props.id} />
            </CustomizedDialogs>
        </div>
    )
}
export default Card;
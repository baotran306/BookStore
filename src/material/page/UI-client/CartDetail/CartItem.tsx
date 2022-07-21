import { Button } from "@mui/material";
import { Delete, Remove, Add, PowerInputSharp } from '@mui/icons-material'
import BpCheckbox from "./BbCheckBox";
import React, { useEffect, useState } from "react";
import './CartItem.css'
const CartItem = (props: any) => {
    const [quantity, setQuantity] = useState(props.item.quantity);
    const handleDecrease = () => {
        setQuantity(() => {
            if (quantity <= 1) {
                return quantity;
            } else {
                return quantity - 1;
            }
        });
    }
    const handleIncrease = () => {
        setQuantity(() => {
            if (quantity !== 0) {
                if (false) {
                    return quantity;
                } else {
                    return quantity + 1;
                }
            };
            return quantity;
        });
        // setShoppingCart({ ...[shoppingCart], quantity_cart: quantity })
    }
    useEffect(() => {
        props.item.quantity = quantity;
        props.handleChangeQuantity(props.item);
    }, [quantity])
    const handleSelect = () => {
        props.item.select = !props.item.select;
        props.handleSelectItem(props.item);
    }
    return (
        <div className="card-item" id='cart-card-item' title={props.item.name}>
            <div className="left">
                <div></div>
                <div><BpCheckbox checked={props.item.select} onClick={handleSelect} /></div>
                <div></div>
            </div>
            <div className="center">
                <div className="top">
                    <img src={`http://127.0.0.1:5000/get-image/${props.item.img}`} />
                </div>
                <div className="bottom">
                    <div className="priceAfterDiscount"><span>{new Intl.NumberFormat().format(props.item.afterDiscountPrice)}</span></div>
                    {props.item.beforeDiscountPrice !== props.item.afterDiscountPrice ?
                        <div className="priceBeforeDiscount">
                            <span>{new Intl.NumberFormat().format(props.item.beforeDiscountPrice)}</span>
                        </div> : <></>
                    }
                </div>
            </div>
            <div className="right">
                <div className='title'><span>{props.item.name}</span></div>
                <div className='quantity-container'>
                    <label className={`input-group-prepend ${quantity <= 1 ? 'disable' : ''}`}
                        style={{ borderRadius: '5px 0 0 5px', borderRight: 'none' }}
                        onClick={handleDecrease}><Remove /></label>
                    <label className='input-quantity'>{quantity}</label>
                    <label className={`input-group-prepend ${quantity === 0 ? 'disable' : ''}`}
                        style={{ borderRadius: '0 5px 5px 0', borderLeft: 'none' }}
                        onClick={handleIncrease}><Add /></label>
                </div>
                <div className="total">
                    <p>Total: </p>
                    <span>{new Intl.NumberFormat().format(quantity * props.item.afterDiscountPrice)}</span>
                </div>
                <div className="btn-item">
                    <Button
                        onClick={() => props.handleRemove(props.item)}
                        style={{ width: '50px', position: 'absolute', right: '0px', top: '-40px' }}>
                        <Delete />
                    </Button>
                </div>
            </div>
        </div>
    )
}
export default CartItem;
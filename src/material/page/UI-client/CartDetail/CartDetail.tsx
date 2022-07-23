import React, { useEffect, useState } from "react";
import { Button, Container } from "react-bootstrap";
import { Dialog, FormControlLabel } from "@mui/material";
import { useNavigate } from "react-router-dom";
import BpCheckbox from "./BbCheckBox";
import Axios from '../../../Axios';
import './CartDetail.css'
import CartItem from "./CartItem";
import LoginDialog from "../login/LoginDialog";
import DialogPayMent from './DialogPayment';
import { Delete, Settings, LocationOn } from "@mui/icons-material";

const CartDetail = (props: any) => {
    const [cartItems, setCartItems] = useState([] as any);
    const [productIsChoose, setProductIsChoose] = useState(0);
    const [total, setTotal] = useState(0);
    const [selectAll, setSelectAll] = useState(false);
    const redirect = useNavigate();
    const [checkLogin, setCheckLogin] = useState(false);
    const [receiver, setReciever] = useState('' as any);
    const [openPayment, setOpenPayment] = useState(false);
    const [checkOut, setCheckOut] = useState(false);
    useEffect(() => {
        let cartTemp = localStorage.getItem('cart');
        if (cartTemp !== null) {
            setCartItems(JSON.parse(cartTemp!).map((data: any) => {
                return {
                    isbn: data.isbn,
                    afterDiscountPrice: data.afterDiscountPrice,
                    beforeDiscountPrice: data.beforeDiscountPrice,
                    name: data.name,
                    quantity: data.quantity,
                    image: data.image,
                    select: false,
                }
            }));
        }

    }, [])
    const customerOrder = (carts: any) => {
        console.log("book: ", JSON.stringify(carts));
        Axios.post(`/customer/order`, {
            list_book: carts,
            last_name: receiver.last_name,
            first_name: receiver.first_name,
            address: receiver.address,
            phone_number: receiver.phone_number,
            email: receiver.email,
            customer_id: receiver.customer_id
        })
            .then((res) => {
                const listProduct = res.data;
                console.log("book: " + res.data.length);
                if (carts.length < cartItems.length) {
                    localStorage.setItem('cart', JSON.stringify(cartItems.filter((data: any) => data.select === false)));
                }
                else {
                    localStorage.removeItem('cart');
                }
                localStorage.removeItem('receiver');
            }).catch(error => {
                console.log(error);

            })
    }
    const handleSelectItem = (item: any) => {
        setCartItems(cartItems.map((data: any) => {
            if (item.isbn === data.isbn) {
                data.select = item.select;
                if (item.select === false) {
                    setProductIsChoose(productIsChoose - 1);
                    setSelectAll(false);
                } else {
                    setProductIsChoose(productIsChoose + 1);
                }
            }
            return data;
        }));
    }
    const handleChangeSelectAll = (e: any) => {
        setSelectAll(e.target.checked);
        if (e.target.checked === true) {
            setProductIsChoose(cartItems.length)
        } else {
            setProductIsChoose(0)
        }
        setCartItems(cartItems.map((data: any) => {
            data.select = e.target.checked;
            return data;
        }));
    }
    useEffect(() => {
        var flag = true;
        cartItems.forEach((data: any) => {
            if (data.select === false) {
                flag = false;
                return;
            }
        });
        setSelectAll(flag);
        setTotal(totalPrice);
    }, [cartItems])
    const totalPrice = () => {
        let totalTemp = 0;
        cartItems.forEach((cart: any) => {
            if (cart.select) {
                totalTemp = cart.quantity * cart.afterDiscountPrice + totalTemp;
            }
        });
        return totalTemp;
    }
    const handleChangeQuantity = (item: any) => {
        setCartItems(cartItems.map((data: any) => {
            if (data.isbn === item.isbn) {
                data.quantity = item.quantity;
            }
            return data;
        }))
    }
    const handleRemove = (item: any) => {
        setCartItems(cartItems.filter((data: any) => data.isbn !== item.isbn));
        setProductIsChoose(productIsChoose > 0 ? productIsChoose - 1 : productIsChoose);
    }
    const handleBuy = () => {
        if (localStorage.getItem('accessToken') === null) {
            setCheckLogin(true);
        } else {
            setOpenPayment(true);
        }

    }
    useEffect(() => {
        if (checkOut) {
            let arrTemp = [] as any;
            arrTemp = cartItems.filter((data: any) => data.select === true);
            let arr = [] as any;
            arr = arrTemp.map(function (data: any) {
                return [
                    data.isbn,
                    data.afterDiscountPrice,
                    data.quantity
                ]
            });
            customerOrder(arr);
        };
    }, [checkOut])
    const handleEditInfoReceiver = () => {
        redirect(`edit-receiver-information`);
    }
    useEffect(() => {
        if (localStorage.getItem('receiver')) {
            let temp = JSON.parse(localStorage.getItem('receiver')!);
            setReciever(temp);
        } else if (localStorage.getItem('accessToken')) {
            let temp = JSON.parse(localStorage.getItem('accessToken')!);
            setReciever(temp);
        }
    }, [props.accessToken])
    return (
        <Container>
            <div id='cartDetailContainer'>
                <div className="cart-top">
                    {props.accessToken ?
                        <div className="navBarCartInfo">
                            <div className="nav-noti">
                                <FormControlLabel className="nav-noti-text" control={<LocationOn />} label={`Địa chỉ nhận hàng`} />
                            </div>
                            <div></div>
                            <div className="nav-item">
                                <div>
                                    <p>{receiver.last_name}{" "}{receiver.first_name}, {receiver.phone_number}, {receiver.address}, {receiver.email}</p>
                                </div>
                                <FormControlLabel className="delete-item-select" control={<Settings />} label={`Thay đổi`} onClick={handleEditInfoReceiver} />
                            </div>
                            <div></div>
                        </div> : <></>}
                </div>
                <div className="cart-top">
                    <div className="navBarCartDetail">
                        <div></div>
                        <div className="nav-item">
                            <FormControlLabel control={<BpCheckbox checked={selectAll} onChange={handleChangeSelectAll} />} label={'Select all'} />
                            {productIsChoose > 0 ? <FormControlLabel className="delete-item-select" control={<Delete />} label={`Remove ${productIsChoose} items`} /> : <></>}
                        </div>
                        <div></div>
                    </div>
                </div>
                <div className="cart-main">
                    {
                        cartItems.map((item: any) =>
                            <CartItem
                                key={item.isbn}
                                item={item}
                                handleSelectItem={handleSelectItem}
                                handleChangeQuantity={handleChangeQuantity}
                                handleRemove={handleRemove}
                            />)
                    }
                </div>
                <div className="cart-bottom">
                    <div className="navBarBottom">
                        <div className="detail">
                            <div></div>
                            <div className="detail-center">
                                <div>
                                    <p>Total price {`(${productIsChoose} products): `}<span>{new Intl.NumberFormat().format(total)}</span></p>
                                </div>

                            </div>
                            <div></div>
                        </div>
                        <div className="btn">
                            <Button variant="contained" disabled={productIsChoose > 0 ? false : true} onClick={handleBuy} style={{ backgroundColor: 'orange', width: '100px', textAlign: 'center' }}>BUY</Button>
                            <DialogPayMent setOpen={setOpenPayment} open={openPayment} setCheckOut={setCheckOut} totalPay={(total / 23000).toFixed(2)} />
                            <LoginDialog open={checkLogin} setOpen={setCheckLogin} title={'Login'} setAccessToken={props.setAccessToken} />
                        </div>
                    </div>
                </div>
            </div>
        </Container>
    )
}
export default CartDetail;
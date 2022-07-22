import React, { useEffect, useState } from "react";
import { Button, Container } from "react-bootstrap";
import { FormControlLabel } from "@mui/material";
import BpCheckbox from "./BbCheckBox";
import './CardDetail.css'
import CartItem from "./CartItem";
import { Delete } from "@mui/icons-material";

const CartDetail = () => {
    const [cartItems, setCartItems] = useState([] as any);
    const [productIsChoose, setProductIsChoose] = useState(0);
    const [total, setTotal] = useState(0);
    const [selectAll, setSelectAll] = useState(false);
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
        let arr = [] as any;
        arr = cartItems.filter((data: any) => data.select === true);
        alert(arr);
    }
    return (
        <Container>
            <div id='cartDetailContainer'>
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
                            <Button variant="contained" onClick={handleBuy} style={{ backgroundColor: 'orange', width: '100px', textAlign: 'center' }}>BUY</Button>
                        </div>
                    </div>
                </div>
            </div>
        </Container>
    )
}
export default CartDetail;
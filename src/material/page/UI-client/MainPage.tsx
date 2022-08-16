import React, { useEffect, useState } from 'react';
import { Col, Container, Row } from 'react-bootstrap';
import { BrowserRouter, Route, Router, Routes } from 'react-router-dom';
import Error from './Error';
import NavigateHeader from './Header';
import ScreenCard from './ScreenShowCard';
import SearchScreen from './SearchScreen';
import CartDetail from './CartDetail/CartDetail';
import CompleteOrder from './ReceiverInfo';
import DeliveryState from './delivery/DeliveryState';
import DeliveryDetail from './delivery/DeliveryDetail';
interface CartTP {
    name: '',
    afterDiscountPrice: '',
    beforeDiscountPrice: '',
    isbn: ''
    quantity: '',
    quantity_current: '',
    image: ''
};
const MainPage = () => {
    const [cart, setCart] = useState<CartTP[]>([])
    const [accessToken, setAccessToken] = useState(localStorage.getItem('accessToken'));

    useEffect(() => {
        if (cart.length !== 0) {
            localStorage.setItem('cart', JSON.stringify(cart));
        }
    }, [cart])
    useEffect(() => {
        if (localStorage.getItem('cart') !== null) {
            setCart(JSON.parse(localStorage.getItem('cart') as any));
        }
    }, [])
    const handleClick = (item: any) => {
        let flag = true;
        setCart(cart.map((data: any) => {
            if (data.isbn === item.isbn) {
                data.quantity = item.quantity;
                flag = false;
            }
            return data;
        }))
        if (flag) {
            setCart([...cart, item]);
        }
    };
    return (
        <div className="main">
            <div>
                <NavigateHeader size={cart.length} cart={cart} accessToken={accessToken} setAccessToken={setAccessToken} />
            </div>
            <Container fluid style={{ paddingTop: '80px' }}>
                <Row>
                    <Routes>
                        <Route path='/shop/:tag_label/:tag' element={<Error />} />
                        <Route path='/search/:bookName' element={<SearchScreen handleClick={handleClick} />} />
                        <Route path='/' element={<ScreenCard handleClick={handleClick} />} />
                        <Route path='/cart' element={<CartDetail setAccessToken={setAccessToken} accessToken={accessToken} />} />
                        <Route path='/cart/edit-receiver-information' element={<CompleteOrder />} />
                        <Route path='/order/delivery-status' element={<DeliveryState />} />
                        <Route path='/order/delivery-detail' element={<DeliveryDetail />} />
                    </Routes>
                </Row>
            </Container>
        </div>)
}

export default MainPage;
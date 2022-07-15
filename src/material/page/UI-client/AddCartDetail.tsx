import React, { useState, useEffect } from 'react';
import { Container, Row, Col } from 'react-bootstrap';
import { Add, Flag, Remove } from "@mui/icons-material";
import Axios from '../../Axios';
import './style/AddCartDetail.css'
import ItemColor from './ItemColor';
import ItemSize from './ItemSize'
const AddCartDetail = (props: any) => {
    const [quantity, setQuantity] = useState(1);

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
    }
    const handleDecrease = () => {
        setQuantity(() => {
            if (quantity <= 1) {
                return quantity;
            } else {
                return quantity - 1;
            }
        });
    }
    return (
        <Container>
            <Row>
                <div className='img-container'>
                    <img src={require('../../image/clothing.png')} />
                </div>
            </Row>
            <Row>
                <Col>
                    <div className='quantity-container'>
                        <span style={{ paddingRight: '10px', fontWeight: 600 }}>Số lượng:</span>
                        <label className={`input-group-prepend ${quantity <= 1 ? 'disable' : ''}`}
                            style={{ borderRadius: '5px 0 0 5px', borderRight: 'none' }}
                            onClick={handleDecrease}><Remove /></label>
                        <label className='input-quantity'>{quantity}</label>
                        <label className={`input-group-prepend ${quantity == 0 ? 'disable' : ''}`}
                            style={{ borderRadius: '0 5px 5px 0', borderLeft: 'none' }}
                            onClick={handleIncrease}><Add /></label>
                    </div>
                </Col>
            </Row>
        </Container >
    )
}
export default AddCartDetail;
import React, { useEffect, useState } from "react";
import {
    EmailOutlined,
    HomeOutlined,
    SmartphoneOutlined,
    HelpOutlineOutlined,
} from "@mui/icons-material";
import { Link, useLocation } from "react-router-dom";
import './DeliveryDetail.css';
import Axios from "../../../Axios";


const DeliveryDetailItem = (props: any) => {
    return (
        <div className="detail">
            <div className="product-detail">
                <div className="img-product-detail">
                    <img src={`http://127.0.0.1:5000/get-image/${props.item.image}`}></img>
                </div>
                <div className="product">
                    <div className="product-name">{props.item.book_name}</div>
                </div>
            </div>
            <div className="price-detail">
                <span>{Intl.NumberFormat().format(props.item.price)}</span>
            </div>
            <div className="quantity-detail">
                <div>{props.item.quantity}</div>
            </div>
            <div className="total-temp-detail">
                <span style={{ display: 'flex', justifyContent: 'right' }}>{Intl.NumberFormat().format(props.item.quantity * props.item.price)}</span>
            </div>
        </div>
    )
}

const DeliveryDetail = () => {
    const bill = {
        receiver_info: {
            address: '',
            cart_id: '1',
            email: '',
            first_name: '',
            last_name: '',
            order_cart_time: '',
            phone_number: '',
            status_id: 0,
            status_name: ''
        },
        list_item: [
            {
                book_name: '',
                cart_id: 0,
                image: '',
                isbn: '',
                price: '',
                quantity: 0
            }
        ],
        total: 0
    }
    const [billDetail, setBillDetail] = useState(bill);
    const location = useLocation();
    let state = location.state as any;

    useEffect(() => {
        console.log(state.cart_id);
        Axios.get(`customer/get-customer-order/${state.cart_id}`)
            .then((res) => {
                let billDetailTemp = res.data[0];
                setBillDetail(billDetailTemp);
            }).catch(error => {
                console.log(error);
            })
    }, [])
    return (
        <div className="delivery-detail">
            <div className="header">
                <div className="infor-customer">
                    <div className="notify-state">
                        <div style={{ display: 'flex', fontSize: '19px', fontWeight: '300' }}>Mã đơn hàng: {billDetail.receiver_info.cart_id} - <span style={{ paddingLeft: '5px', fontWeight: '500' }}>
                            {billDetail.receiver_info.status_id === 1 ? 'Chờ xác nhận' :
                                billDetail.receiver_info.status_id === 2 ? 'Đang giao' :
                                    billDetail.receiver_info.status_id === 3 ? 'Đã giao' :
                                        'Đã hủy'}
                        </span></div>
                        <div>Ngày đặt: {billDetail.receiver_info.order_cart_time}</div>
                    </div>
                    <div className="name" style={{ fontWeight: '500' }}><HelpOutlineOutlined className="icon" /><span>{billDetail.receiver_info.last_name}{" "}{billDetail.receiver_info.first_name}</span></div>
                    <div className="phoneNumber"><SmartphoneOutlined className="icon" /><span>{billDetail.receiver_info.phone_number}</span></div>
                    <div className="address"><HomeOutlined className="icon" /><span>{billDetail.receiver_info.address}</span></div>
                    <div className="mail"><EmailOutlined className="icon" /><span>{billDetail.receiver_info.email}</span></div>
                </div>
            </div>
            <div className="main">
                <div className="top">
                    <div className="navNar-detail">
                        <div className="product-title">
                            <div></div>
                            <div>Tên sản phẩm</div>
                            <div></div>
                        </div>
                        <div className="price-title">
                            <div></div>
                            <div>Giá tiền</div>
                            <div></div>
                        </div>
                        <div className="quantity-title">
                            <div></div>
                            <div>Số lượng</div>
                            <div></div>
                        </div>
                        <div className="total-temp-title">
                            <div></div>
                            <div style={{ display: 'flex', justifyContent: 'right' }}>Tạm tính</div>
                            <div></div>
                        </div>
                    </div>
                </div>
                <div className="center">
                    {billDetail.list_item.map((item: any) => (
                        <DeliveryDetailItem key={item.cart_id} item={item} />)
                    )}
                </div>
                <div className="bottom">
                    <div className="end-line">
                        <div className="total-title">Thành tiền</div>
                        <div className="total-price"><span>{Intl.NumberFormat().format(billDetail.total)}</span></div>
                    </div>
                </div>
            </div>
            <div className="footer">
                <div className="link-back">
                    <Link to={"/order/delivery-status"}>Quay lại</Link>
                </div>
            </div>
        </div>
    )
}
export default DeliveryDetail;
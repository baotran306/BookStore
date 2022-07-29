import React from "react";
import './DeliveryItem.css'
import { LocalShipping, HelpOutlineOutlined, PaidOutlined } from '@mui/icons-material'
import { Button, Tooltip } from "@mui/material";
import { useNavigate } from "react-router-dom";
function Items(props: any) {
    return (
        <div className="main">
            <div className="left">
                <img src={`http://127.0.0.1:5000/get-image/${props.item.image}`} alt="" />
            </div>
            <div className="center">
                <div className="title">{props.item.book_name}</div>
                <div className="quantity">{"X" + props.item.quantity}</div>
            </div>
            <div className="right">
                <div></div>
                <div className="center-price">
                    <div className="price-after-discount">
                        <span>{Intl.NumberFormat().format(props.item.quantity * props.item.price)}</span>
                    </div>
                </div>
                <div></div>
            </div>
        </div >
    )
}
const DeliveryItem = (props: any) => {
    const navigate = useNavigate();
    const handleClickDetail = () => {
        navigate('/order/delivery-detail', {
            state: {
                cart_id: props.item.receiver_info.cart_id,
            }
        });
    }
    return (
        <div className="container-delivery-card">
            <div className="card-deliver">
                <div className="header">
                    <div></div>
                    <div className="card-delivery-status">
                        <div className="notify-status">
                            <LocalShipping style={{ paddingRight: '5px' }} />
                            <span>{props.item.receiver_info.status_id === 1 ? 'Đơn hàng chờ xác nhận' :
                                props.item.receiver_info.status_id === 2 ? 'Đơn hàng đang giao' :
                                    props.item.receiver_info.status_id === 3 ? 'Đơn hàng đã giao' :
                                        'Đơn hàng đã hủy'}</span>
                        </div>
                        <span>
                            <Tooltip title={`Date: ${props.item.receiver_info.order_cart_time}`} arrow>
                                <HelpOutlineOutlined style={{ paddingLeft: '5px', fontSize: '22px' }} />
                            </Tooltip>
                            |
                        </span>
                        <span className="status">{
                            props.item.receiver_info.status_id === 1 ? 'Chờ xác nhận' :
                                props.item.receiver_info.status_id === 2 ? 'Đang giao' :
                                    props.item.receiver_info.status_id === 3 ? 'Đã giao' :
                                        'Đã hủy'}</span>
                    </div>
                    <div></div>
                </div>
                <div className="items">
                    {props.item.list_item.map((item: any) => <Items item={item} />)}
                </div>
            </div>
            <div className="card-deliver-footer">
                <div className="right">
                    <div className="total">
                        <div></div>
                        <div></div>
                        <div>
                            <PaidOutlined sx={{ paddingRight: '5px', fontSize: '24px' }} />
                            <span>Thành tiền: </span>
                            <span className='price'>{Intl.NumberFormat().format(props.item.total)}</span>
                        </div>
                    </div>
                </div>
                <div className="left">
                    <Button style={{ backgroundColor: '#ee4d2d', color: 'white' }}>Mua lại</Button>
                    <Button>Hủy</Button>
                    <Button onClick={handleClickDetail}>Chi tiết đơn hàng</Button>
                </div>
            </div>
        </div>
    )
}
export default DeliveryItem;
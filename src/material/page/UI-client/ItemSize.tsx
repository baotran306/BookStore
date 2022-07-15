import React from "react";
import './style/ItemSize.css'
const ItemSize = (props: any) => {
    const handleClickSize = () => {
        props.setIsSelectSize(() => {
            if (props.quantity === 0) {
                return { select: false, id: props.id, quantity: props.quantity };
            } else {
                return { select: true, id: props.id, quantity: props.quantity };
            }
        })
    }
    return (
        <div className={`card ${props.select ? 'select' : ''}`} onClick={handleClickSize}>
            <div>
                <label>Size:<span>{props.size}</span> </label>
            </div>
            <div>
                <label>Stocks:<span>{props.quantity}</span> </label>
            </div>
        </div>
    )
}
export default ItemSize;
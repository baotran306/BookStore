import React from "react";
import { useNavigate, useParams } from "react-router-dom";

const Error = () => {
    const { search } = useParams();
    // alert(search);
    return (
        <div style={{ backgroundColor: 'red', width: '100%', height: '150vh' }}>
            <h1>Error</h1>
        </div>
    )
}
export default Error;
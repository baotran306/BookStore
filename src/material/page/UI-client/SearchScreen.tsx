import React, { useState, useEffect, useRef } from 'react';
import { Button, Container } from 'react-bootstrap';
import CardItem from './CardItem';
import Axios from '../../Axios';
import './style/ScreenCard.css';
import { Link, useParams } from 'react-router-dom';
const SearchScreen = (props: any) => {
    const [books, setBooks] = useState([]);
    const { bookName } = useParams();
    // alert(bookName) ;
    const getBooks = () => {
        Axios.post(`/book/get-list-book-by-name`, {
            bookName: bookName
        })
            .then((res) => {
                const listProduct = res.data;
                console.log("book: " + listProduct);
                setBooks(
                    listProduct.map((b: any) => {
                        return {
                            isbn: b.isbn,
                            image: b.image,
                            title: b.book_name,
                            price_current: b.price,
                            is_new: b.is_new,
                            percent_discount: b.percent_discount,
                            tag: "b.tag",
                            tag_label: "b.label.tag_label",
                        };
                    })
                );
            })
            .catch((error) => {
                console.log(error);
            });
    }

    useEffect(() => {
        getBooks();

    }, [bookName]);
    return (
        <Container>
            <div className="wrapper-item">
                {books.map((b: any) => (
                    <CardItem
                        key={b.isbn}
                        image={b.image}
                        title={b.title}
                        percent_discount={b.percent_discount ? (b.percent_discount) : null}
                        price_current={b.price_current}
                        is_new={b.is_new}
                        isbn={b.isbn}
                        tag={b.tag}
                        handleClick={props.handleClick}
                        tag_label={b.tag_label}
                    />
                ))}
            </div>
        </Container >
    );
};

export default SearchScreen;

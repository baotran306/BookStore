import React, { useState, useEffect, useRef } from 'react';
import { Button, Container } from 'react-bootstrap';
import CardItem from './CardItem';
import Axios from '../../Axios';
import Slider from "react-slick";
import { ArrowForwardIos, ArrowBackIos } from '@mui/icons-material';
import './style/ScreenCard.css';
import { Link } from 'react-router-dom';
import { log } from 'console';

const SampleNextArrow = (props: any) => {
  const { className, style, onClick
  } = props;
  return (
    <div
      className={className}
      style={{ ...style, display: "block", right: '15px' }}
      onClick={onClick}
    ><ArrowForwardIos style={{ fontSize: '24px', color: 'black' }} /></div>
  );
};

function SamplePrevArrow(props: any) {
  const { className, style, onClick } = props;
  return (
    <div
      className={className}
      style={{ ...style, display: "block", left: '-12px', zIndex: 1 }}
      onClick={onClick}
    ><ArrowBackIos style={{ fontSize: '24px', color: 'black' }} /></div>
  );
};
const ScreenCard = (props: any) => {
  const [books, setBooks] = useState([]);
  const [newBooks, setNewBooks] = useState([]);
  const [bestSellerBooks, setBestSellerBooks] = useState([]);

  // const slickRef = useRef(null);
  // console.log(slickRef.current);
  const getNewBooks = () => {
    Axios.get('/book/get-list-new-book')
      .then((res) => {
        const listProduct = res.data;
        console.log("book: " + res.data.length);
        setNewBooks(
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
        getBestSeller();
        getBooks();
      })
      .catch((error) => {
        console.log(error);
      });
  }
  const getBooks = () => {
    Axios.get('/book/get-list-book')
      .then((res) => {
        const listProduct = res.data;
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
          }))
      }).catch(error => {
        console.log(error);

      })
  }
  const getBestSeller = () => {
    Axios.get('/book/get-list-best-seller-book')
      .then((res) => {
        const listProduct = res.data;
        console.log("book: " + res.data.length);
        setBestSellerBooks(
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
          }))
      }).catch(error => {
        console.log(error);

      })
  }
  useEffect(() => {
    getNewBooks();

  }, []);
  return (
    <Container>
      <div className='container'>
        <div className='design new'>
          <div className='clearfix'>
            <strong className='design-title'>
              Sách mới
            </strong>
          </div>
          <Slider
            infinite={(newBooks.length > 5)}
            slidesToShow={5}
            slidesToScroll={1}
            nextArrow={<SampleNextArrow />}
            prevArrow={<SamplePrevArrow />}
          >
            {newBooks.map((b: any) =>
            (<CardItem
              key={b.isbn}
              image={b.image}
              title={b.title}
              percent_discount={b.percent_discount ? (b.percent_discount) : null}
              price_current={b.price_current}
              is_new={b.is_new}
              isbn={b.isbn}
              tag={b.tag}
              tag_label={b.tag_label}
              handleClick={props.handleClick}
            />))}
          </Slider>
          <div className='btn-seeMore'>
            <Button title='see more'>Xem thêm</Button>
          </div>
        </div>
      </div>
      <div className='container'>
        <div className='design seller'>
          <div className='clearfix'>
            <strong className='design-title'>
              Sách bán chạy
            </strong>
          </div>
          <Slider
            infinite={bestSellerBooks.length > 5}
            slidesToShow={5}
            slidesToScroll={1}
            nextArrow={<SampleNextArrow />}
            prevArrow={<SamplePrevArrow />}
          >
            {bestSellerBooks.map((b: any) => //b.percent_discount ?
            (<CardItem
              key={b.isbn}
              image={b.image}
              title={b.title}
              percent_discount={b.percent_discount ? (b.percent_discount) : null}
              price_current={b.price_current}
              is_new={b.is_new}
              isbn={b.isbn}
              tag={b.tag}
              tag_label={b.tag_label}
              handleClick={props.handleClick}
            />))}
          </Slider>
          <div className='btn-seeMore'>
            <Button title='see more'>Xem thêm</Button>
          </div>
        </div>
      </div>
      <Container>
        <div className='container clearfix'>
          <h4 className='float-start'>Sách</h4>
        </div>
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
              tag_label={b.tag_label}
              handleClick={props.handleClick}
            />
          ))}
        </div>
      </Container>
    </Container >
  );
};

export default ScreenCard;

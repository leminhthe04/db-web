import { useEffect, useState } from "react";
import axios from 'axios';
import Header from "../components/Header";
import Footer from "../components/Footer";
import Pagination from "../components/Pagination";
import ProductUpdate from "./ProductUpdate";
import { useNavigate } from "react-router-dom";

const result = {
    "status": 200,
    "msg": "Found products",
    "data": [
        {
            "product_id": "49",
            "product_name": "An Ao dai Viet Nam",
            "price": "15000.00",
            "quantity": "50",
            "category_id": "21",
            "category_name": "Ao dai",
            "seller_id": "1",
            "seller_name": "John Doe Mot",
            "buying_count": "0",
            "avg_rating": ".00",
            "store_id": "1",
            "store_name": "Store A1",
            "status": "Available",
            "brand": null
        },
        {
            "product_id": "50",
            "product_name": "Coffee1",
            "price": "23000.00",
            "quantity": "100",
            "category_id": "2",
            "category_name": "Books",
            "seller_id": "1",
            "seller_name": "John Doe Mot",
            "buying_count": "0",
            "avg_rating": "3.17",
            "store_id": "1",
            "store_name": "Store A1",
            "status": "Available",
            "brand": "Nescafe"
        },
        {
            "product_id": "55",
            "product_name": "An Ao dai Cach tan",
            "price": "15000.00",
            "quantity": "50",
            "category_id": "21",
            "category_name": "Ao dai",
            "seller_id": "1",
            "seller_name": "John Doe Mot",
            "buying_count": "0",
            "avg_rating": ".00",
            "store_id": "1",
            "store_name": "Store A1",
            "status": "Available",
            "brand": null
        }
    ]
}

export default function ProductsManagement() {
    const navigate = useNavigate();
    const [editMode, setEditMode] = useState(false);
    const [productList, setProductList] = useState([]);
    const [priceToggle, setPriceToggle] = useState(false);
    const [nameToggle, setNameToggle] = useState(false);
    const [currentPage, setCurrentPage] = useState(0);
    const [page, setPage] = useState(null);
    const [errors, setErrors] = useState(null);
    const [token, setToken] = useState(null);
    const [count, setCount] = useState(0);
    const [keyword, setKeyword] = useState("");

    const [prodDetail, setProDetail] = useState(null);



    useEffect(() => {
        // axios.get("http://localhost:8000/api/product/getAll?page=0&limit=5",)
        //     .then((response) => {
        //         console.log(response);
        //         const products = response.data.data;
        //         const pageNum = response.data.totalPage;
        //         setPage(pageNum);
        //         // console.log(JSON.stringify(products));
        //         setProductList(products);
        //     })
        //     .catch((error) => {
        //         if (error.response) {
        //             alert(error.response.data.msg);
        //         } else {
        //             console.error('Error:', error.message);
        //         }
        //     })

        setProductList(result.data);
    }, [count])


    function disableEditMode() {
        setEditMode(false);
    }

    function handleUpdateProduct(prodID) {
        navigate(`/admin/edit-product/${prodID}`);
    }

    function handlePageClick(pageNum) {
        const index = Number(pageNum);
        axios.get(`http://localhost:8000/api/product/getAll?page=${index}&limit=5`,)
            .then((response) => {
                console.log(response);
                setCurrentPage(pageNum)
                const products = response.data.data;
                // console.log(JSON.stringify(products));
                setProductList(products);
            })
            .catch((error) => {
                if (error.response) {
                    alert(error.response.data.msg);
                } else {
                    console.error('Error:', error.message);
                }
            })
    }

    function handleSearch() {
        alert("Search");
        if (keyword == null) {
            alert("Hãy điền từ khóa để tìm kiếm")
        }
        axios.get(`http://localhost:8000/api/product/getAll?page=0&limit=5&filter=${keyword}`,)
            .then((response) => {
                console.log(response);
                const products = response.data.data;
                const pageNum = response.data.totalPage;
                setPage(pageNum);
                // console.log(JSON.stringify(products));
                setProductList(products);
            })
            .catch((error) => {
                if (error.response) {
                    alert(error.response.data.msg);
                } else {
                    console.error('Error:', error.message);
                }
            })
    }

    function handleDeleteProduct(prodID) {
        // alert(prodID + token);
        axios.delete(`http://localhost:8000/api/product/DeleteProduct/${prodID}`, null, {
            headers: {
                Authorization: `Bearer ${token}`, // Replace <your-auth-token> with the actual token
            },
        })
            .then((response) => {
                alert(response.data.msg);
                setCount((pre) => pre + 1);
            })
            .catch((error) => {
                if (error.response) {
                    alert(error.response.data.msg);
                } else {
                    console.error('Error:', error.message);
                }
            })

    }

    return (
        <>
            <Header page="product-manage" role="admin" />
            <div className="h-10"></div>
            <main>
                <div className="w-full flex justify-end items-center mb-4">
                    <div className="add-product inline-block bg-gray-300 h-full relative right-20 p-2 hover:bg-slate-200" onClick={() => { navigate("/product-new") }}>
                        <div className="font-bold ">Thêm sản phẩm</div>
                    </div>
                </div>

                {editMode && (
                    <>
                        <ProductUpdate disableEditMode={disableEditMode} />
                        <div className="fixed inset-0 bg-black bg-opacity-30 z-10"></div>
                    </>
                )}
                <table className="w-11/12 min-h-80 text-center text-bold text-xl m-auto">
                    <thead>
                        <tr className="h-14 bg-purple-1 border rounded-e-sm">
                            <td className="border border-black  w-1/12">STT</td>
                            <td className="border border-black  w-2/12">Tên sản phẩm</td>
                            <td className="border border-black  w-1/12">Danh mục</td>
                            <td className="border border-black  w-2/12">Giá</td>
                            <td className="border border-black  w-1/12">Số lượng</td>
                            <td className="border border-black  w-1/12">Rating</td>
                            <td className="border border-black  w-1/12">Cửa hàng</td>
                            <td className="border border-black  w-2/12">Người bán</td>
                            <td className="border border-black  w-1/12"> Tùy chỉnh</td>
                        </tr>
                    </thead>
                    <tbody>
                        {productList.map((prod, index) => (
                            <tr className="h-14 border rounded-e-sm">
                                <td className="border border-black  w-1/12">{index+1}</td>
                                <td className="border border-black  w-2/12">{prod.product_name}</td>
                                <td className="border border-black  w-1/12">{prod.category_name}</td>
                                <td className="border border-black  w-1.5/12">{prod.price}</td>
                                <td className="border border-black  w-1/12">{prod.buying_count}</td>
                                <td className="border border-black  w-1/12">{prod.avg_rating}</td>
                                <td className="border border-black  w-1/12">{prod.store_name}</td>
                                <td className="border border-black  w-2/12">{prod.seller_name}</td>
                                <td className="border border-black  w-1/12">
                                <div className="flex justify-center items-center ">
                                    <button className="bg-green-600 px-4 rounded-md font-bold text-white uppercase"
                                        onClick={() => handleUpdateProduct(index)}
                                    >
                                        Sửa
                                    </button>
                                    <div className="w-2"></div>
                                    <div className="bg-red-600 px-4 rounded-md font-bold text-white uppercase " 
                                        onClick={() => handleDeleteProduct(index)}
                                    >
                                        Xóa
                                    </div>
                                </div>
                                </td>
                               
                            </tr>
                        ))}

                    </tbody>
                </table>

                <div className="h-10">

                </div>

                <div className="flex justify-end mr-20 ">
                    {/* <Pagination /> */}
                    {Array.from({ length: 10 }, (_, i) => (
                        <button
                            key={i}
                            onClick={() => handlePageClick(i)} // Pass the page number to the handler
                            className={`px-3 py-1 mx-1 hover:bg-blue-300 ${currentPage === i ? "bg-blue-500 text-white" : "bg-gray-200"
                                } rounded`}
                        >
                            {i + 1}
                        </button>
                    ))}
                </div>

                <div className="h-10">

                </div>

                {/* 
                <div>
                    <Footer />
                </div> */}
            </main>


        </>
    )
}
import { useEffect, useState } from "react";
import axios from 'axios';
import Header from "../components/Header";
import Footer from "../components/Footer";
import Pagination from "../components/Pagination";
import ProductUpdate from "./ProductUpdate";
import { useNavigate } from "react-router-dom";

// const productList = [
//     {
//         pname: "Sản phẩm 1",
//         pdescription: "Mô tả sản phẩm",
//         catory: "Điện thoại",
//         shop: "Cửa hàng của mèo",
//         seller: "Mèo",
//         sold_quantity: 100,
//         rating: 1.2
//     }
// ]

export default function ProductsManagement() {
    const navigate = useNavigate();
    const [editMode, setEditMode] = useState(false);
    // const [productList, setProductList] = useState([]);
    const [priceToggle, setPriceToggle] = useState(false);
    const [nameToggle, setNameToggle] = useState(false);
    const [currentPage, setCurrentPage] = useState(0);
    const [page, setPage] = useState(null);
    const [errors, setErrors] = useState(null);
    const [token, setToken] = useState(null);
    const [count, setCount] = useState(0);
    const [keyword, setKeyword] = useState("");

    const [prodDetail, setProDetail] = useState(null);



    // useEffect(() => {
    //     const loadToken = localStorage.getItem("token");
    //     if (loadToken) setToken(loadToken);
    //     axios.get("http://localhost:8000/api/product/getAll?page=0&limit=5",)
    //         .then((response) => {
    //             console.log(response);
    //             const products = response.data.data;
    //             const pageNum = response.data.totalPage;
    //             setPage(pageNum);
    //             // console.log(JSON.stringify(products));
    //             setProductList(products);
    //         })
    //         .catch((error) => {
    //             if (error.response) {
    //                 alert(error.response.data.msg);
    //             } else {
    //                 console.error('Error:', error.message);
    //             }
    //         })
    // }, [count])


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

            <div className="m-4 mb-4">
                <span className=" font-medium">All Products</span>
            </div>
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
                            <td className="border border-black  w-1/12">Người bán</td>
                            <td className="border border-black  w-1/12"> Tùy chỉnh</td>
                        </tr>
                    </thead>
                    <tbody>
                        {Array.from({ length: 10 }, (_, i) => (
                            <tr className="h-14 border rounded-e-sm">
                                <td className="border border-black  w-1/12">{i+1}</td>
                                <td className="border border-black  w-2/12">Tên sản phẩm</td>
                                <td className="border border-black  w-1/12">Danh mục</td>
                                <td className="border border-black  w-1.5/12">Giá</td>
                                <td className="border border-black  w-1/12">Số lượng</td>
                                <td className="border border-black  w-1/12">Rating</td>
                                <td className="border border-black  w-1/12">Cửa hàng</td>
                                <td className="border border-black  w-1/12">Người bán</td>
                                <td className="border border-black  w-1/12">
                                <div className="flex justify-center items-center ">
                                    <button className="bg-green-600 px-4 rounded-md font-bold text-white uppercase">
                                        Sửa
                                    </button>
                                    <div className="w-2"></div>
                                    <div className="bg-red-600 px-4 rounded-md font-bold text-white uppercase " >
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
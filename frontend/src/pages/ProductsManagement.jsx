import { useEffect, useState } from "react";
import axios from "axios";
import Header from "../components/Header";
import Footer from "../components/Footer";
import Pagination from "../components/Pagination";
import ProductUpdate from "./ProductUpdate";
import { useNavigate } from "react-router-dom";


export default function ProductsManagement() {
  const navigate = useNavigate();
  const [editMode, setEditMode] = useState(false);
  const [productList, setProductList] = useState([]);
  const [priceToggle, setPriceToggle] = useState(false);
  const [nameToggle, setNameToggle] = useState(false);
  const [currentPage, setCurrentPage] = useState(0);
  const [pageNum, setPageNum] = useState(null);
  const [errors, setErrors] = useState(null);
  const [token, setToken] = useState(null);
  const [count, setCount] = useState(0);
  const [keyword, setKeyword] = useState("");
  const [cat_id, setCat_id] = useState(null);
  const [catList, setCatList] = useState([]);
  const [modeFilter, setModeFilter] = useState(false);

  const [prodDetail, setProDetail] = useState(null);

  useEffect( () => {

    axios.post("http://localhost/api/product/get", {
          "offset": 0,
          "limit": 10,
      })
      .then((response) => {
        // console.log("Check reponse: " ,response.data.data.data);
        const products = response.data.data.data;
    
        // console.log("Check numpage: ", response.data.data.num_page);
        setPageNum(response.data.data.num_page);
        // console.log(JSON.stringify(products));
        setProductList(products);
      })
      .catch((error) => {
        if (error.response) {
          alert(error.response.data.msg);
        } else {
          console.error("Error:", error.message);
        }
      });
    const fetchData = async () => {
    try {
        // const sellerData = await axios.post(`http://localhost/api/seller/get`, { "limit": 999999, "offset": 0 });
        // console.log("Check seller data: ", sellerData.data.data);
        // setSellerList(sellerData.data.data);
        const catData = await axios.get(`http://localhost/api/category/all`);
        console.log("Check cat data: ", catData.data.data);
        setCatList(catData.data.data);

    } catch (error) {
        console.error("Error fetching data:", error);
    }
    };

    fetchData(); 
    
  }, [count]);

  function disableEditMode() {
    setEditMode(false);
  }

  function handleUpdateProduct(prodID) {
    navigate(`/edit-product/${prodID}`);
  }

  function handlePageClick(index) {
    // const index = Number(pageNum);   

    if(! modeFilter) {
        axios
        .post(`http://localhost/api/product/get`, { 
          "offset": index*10,
          "limit": 10,
        })
        .then((response) => {
          console.log(response);
          setCurrentPage(index);
          const products = response.data.data.data;
          console.log(JSON.stringify(products));
          setProductList(products);
        })
        .catch((error) => {
          if (error.response) {
            alert(error.response.data.msg);
          } else {
            console.error("Error:", error.message);
          }
        });
    } else {
        console.log("cate_id: ", cat_id);
        const catID = Number(cat_id);
        setCurrentPage(index);
    
        axios.post(`http://localhost/api/product/get/category/${catID}`, { 
            "offset": index*10, 
            "limit": 10 
        })
            .then((reponse) => {
                console.log(reponse);
                const products = reponse.data.data.data;
                const pageNum = reponse.data.data.page_count;
                setPageNum(pageNum);
                setProductList(products);
            })
    }
   
  }

  function handleSearch() {
    alert("Search");
    if (keyword == null) {
      alert("Hãy điền từ khóa để tìm kiếm");
    }
    axios
      .get(
        `http://localhost:8000/api/product/getAll?page=0&limit=5&filter=${keyword}`
      )
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
          console.error("Error:", error.message);
        }
      });
  }

  async function hanldeFilter() {
    setModeFilter(true);
    // setCat_id(event.target.value);
    // alert("cate_id: ", cat_id);
    console.log("cate_id: ", cat_id);
    const catID = Number(cat_id);

    
    // if(!event.target.value || event.target.value === 0 ){
    //     alert("Chọn loại sản phẩm để lọc");
    // }
    axios.post(`http://localhost/api/product/get/category/${catID   }`, { 
        "offset": 0, 
        "limit": 10 
    })
        .then((reponse) => {
            console.log(reponse);
            const products = reponse.data.data.data;
            const pageNum = reponse.data.data.page_count;
            setPageNum(pageNum);
            setProductList(products);
        })
  }

  function handleDeleteProduct(prodID) {
    // alert(prodID + token);
    axios
      .delete(
        `http://localhost/api/product/delete/${prodID}`
      )
      .then((response) => {
        console.log(response);
        alert(response.data.msg);
        setCount((pre) => pre + 1);
      })
      .catch((error) => {
        if (error.response) {
          alert(error.response.data.msg);
        } else {
          console.error("Error:", error.message);
        }
      });
  }

  return (
    <>
      <Header page="product-manage" role="admin" />

      <div className="m-4 mb-4">
        <span className=" font-medium">All Products</span>
      </div>
      <main>
        <div className="w-full flex justify-between items-center mb-4">
            <div className="p-2 ml-20 font-bold flex items-center" >
                <label className="bg-gray-300 w-60">Lọc theo danh mục</label>
                <select name="category" className={`px-2 block w-4/5 h-8 my-2 rounded-md hover:bg-blue-100 outline-none  `} 
                    onChange={(e) => {
                        setCat_id(e.target.value);
                    }}
                    value={cat_id}
                >
                    <option value="" >Chọn loại sản phẩm</option>
                    {catList.length > 0 && catList.map((cat) => (
                        <option value={cat.id} key={cat.id} >{cat.name}</option>
                        ))}
                </select>
                <div className="bg-green-200 p-2 rounded-md px-4"
                    onClick={hanldeFilter}
                >Lọc</div>
            </div>
            
          <div
            className="add-product inline-block bg-gray-300 h-full relative right-20 p-2 hover:bg-slate-200"
            onClick={() => {
              navigate("/product-new");
            }}
          >
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
              <td className="border border-black  w-1/12">Giá</td>
              <td className="border border-black  w-1/12">SL trong kho</td>
              <td className="border border-black  w-1/12">SL đã bán</td>
              <td className="border border-black  w-1/12">Rating</td>
              <td className="border border-black  w-1/12">Cửa hàng</td>
              <td className="border border-black  w-1/12">Người bán</td>
              <td className="border border-black  w-1/12">Trạng thái</td>
              <td className="border border-black  w-1/12"> Tùy chỉnh</td>
            </tr>
          </thead>
          <tbody>
            {/* {producLis(_, i) => (
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
                               
                            </tr>0
                        ))} */}
            {productList.map((product, index) => (
                 
                    <tr className="h-14 border rounded-e-sm">
                                <td className="border border-black  w-1/12">{index+1}</td>
                                <td className="border border-black  w-2/12">{product.product_name}</td>
                                <td className="border border-black  w-1/12">{product.category_name}</td>
                                <td className="border border-black  w-1/12 ">{product.price}</td>
                                <td className="border border-black  w-1/12">{product.quantity}</td>
                                <td className="border border-black  w-1/12">{product.buying_count}</td>
                                <td className="border border-black  w-1/12">{product.avg_rating}</td>
                                <td className="border border-black  w-1/12">{product.store_name}</td>
                                <td className="border border-black  w-1/12">{product.seller_name}</td>
                                <td className="border border-black  w-1/12">{product.status}</td>
                                <td className="border border-black  w-1/12">
                                <div className="flex justify-center items-center ">
                                    <button className="bg-green-600 px-4 rounded-md font-bold text-white uppercase"
                                        onClick={() => handleUpdateProduct(product.product_id)}
                                    >
                                        Sửa
                                    </button>
                                    <div className="w-2"></div>
                                    <div className="bg-red-600 px-4 rounded-md font-bold text-white uppercase"
                                        onClick={() => handleDeleteProduct(product.product_id)}
                                    >
                                        Xóa
                                    </div>
                                </div>
                                </td>
                            </tr>
            ))}
          </tbody>
        </table>

        <div className="h-10"></div>

        <div className="flex justify-end mr-20 ">
          {/* <Pagination /> */}
          {Array.from({ length: pageNum }, (_, i) => (
            <button
              key={i}
              onClick={() => handlePageClick(i)} // Pass the page number to the handler
              className={`px-3 py-1 mx-1 hover:bg-blue-300 ${
                currentPage === i ? "bg-blue-500 text-white" : "bg-gray-200"
              } rounded`}
            >
              {i + 1}
            </button>
          ))}
        </div>

        <div className="h-10"></div>

        {/* 
                <div>
                    <Footer />
                </div> */}
      </main>
    </>
  );
}

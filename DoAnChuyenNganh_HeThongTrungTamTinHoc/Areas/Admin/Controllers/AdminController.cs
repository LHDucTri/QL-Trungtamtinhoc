﻿using DoAnChuyenNganh_HeThongTrungTamTinHoc.Filter;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh_HeThongTrungTamTinHoc.Filter;

namespace DoAnChuyenNganh_HeThongTrungTamTinHoc.Areas.Admin.Controllers
{
    [AdminAuthorize]
    public class AdminController : Controller
    {
        
        public ActionResult Index()
        {
            return View();
        }

    }
}
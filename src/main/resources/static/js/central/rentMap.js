// 임대 매물 지도 화면 JS
// DB 데이터: /rent/list-data

// 지도 마커용 단지 집계 데이터
let complexMarkerList = [];

let rentListingList = [];
// 단지별 상세 매물 캐시
let complexRentCache = {};
let map;
// let geocoder;
let markers = [];
let selectedRentNo = null;
let selectedAptCmplexNo = null;
let currentType = "ALL";

// 초기 지도 화면: 송파구/강동·하남 인근
const INITIAL_MAP_CENTER = new kakao.maps.LatLng(37.514575, 127.105399);
const INITIAL_MAP_LEVEL = 5;

let isFirstMapRender = true;

/*
 * 공고 상세페이지 또는 매물 상세페이지에서 뒤로가기 했을 때
 * 사용자가 보고 있던 단지/매물을 다시 열기 위한 sessionStorage key
 */
const RENT_MAP_RESTORE_KEY = "rentMapRestoreState";

document.addEventListener("DOMContentLoaded", function () {
    initMap();
    bindEvents();
    loadRentListings();
});

/*
 * 브라우저 뒤로가기로 페이지가 복원되는 경우
 * 이전에 선택했던 단지와 매물을 다시 표시한다.
 */
window.addEventListener("pageshow", function () {
    if (rentListingList.length > 0) {
        restoreRentMapSelection();
    }
});

/**
 * 카카오 지도 초기화
 */
function initMap() {
    const mapContainer = document.getElementById("rentMap");

    if (!mapContainer) {
        console.error("#rentMap 영역을 찾을 수 없습니다.");
        return;
    }

    const mapOption = {
        center: INITIAL_MAP_CENTER,
        level: INITIAL_MAP_LEVEL
    };

    map = new kakao.maps.Map(mapContainer, mapOption);
}

/**
 * 지도 마커용 단지 목록 조회
 */
function loadRentListings() {
    const apiUrl = (typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "") + "/rent/map-data";

    fetch(apiUrl)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("지도 마커 목록 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {
            console.log("지도 마커 데이터:", data);

            if (!data.success) {
                alert(data.message || "지도 마커 목록을 불러오지 못했습니다.");
                return;
            }

            // 중요: 마커용 데이터는 complexMarkerList에 저장
            complexMarkerList = normalizeRentList(data.list || []);

            if (complexMarkerList.length === 0) {
                showEmptyMapMessage();
                return;
            }

            renderMarkers();
            restoreRentMapSelection();
        })
        .catch(function (error) {
            console.error("지도 마커 목록 조회 오류:", error);
            alert("지도 마커 목록 조회 중 오류가 발생했습니다.");
        });
}

/**
 * DB 데이터 화면용 보정
 */
function normalizeRentList(list) {
    return list.map(function (item) {
        const normalized = Object.assign({}, item);

        normalized.rentLstgNo = nvl(item.rentLstgNo);
        normalized.rentTypeCd = nvl(item.rentTypeCd);
        normalized.rentTypeNm = nvl(item.rentTypeNm, item.rentTypeCd);
        normalized.rentTtl = nvl(item.rentTtl, item.aptCmplexNm);
        normalized.aptCmplexNo = nvl(item.aptCmplexNo);
        normalized.annNo = nvl(item.annNo);
        normalized.annTtl = nvl(item.annTtl, item.rentTtl);
        normalized.aptCmplexNm = nvl(item.aptCmplexNm, "아파트 단지");
        normalized.dorojuso = nvl(item.dorojuso);
        normalized.latVal = item.latVal != null && item.latVal !== "" ? Number(item.latVal) : null;
        normalized.lonVal = item.lonVal != null && item.lonVal !== "" ? Number(item.lonVal) : null;
        normalized.dongNm = nvl(item.dongNm, item.dongNo);
        normalized.dongNo = nvl(item.dongNo);
        normalized.ho = nvl(item.ho);
        normalized.floor = item.floor || "-";
        normalized.empty = nvl(item.empty, "-");
        normalized.dpstAmt = Number(item.dpstAmt || 0);
        normalized.jsCount = Number(item.jsCount || 0);
        normalized.peCount = Number(item.peCount || 0);

        normalized.minJsDpstAmt =
            item.minJsDpstAmt != null && item.minJsDpstAmt !== ""
                ? Number(item.minJsDpstAmt)
                : null;

        normalized.minPeMonthlyRentAmt =
            item.minPeMonthlyRentAmt != null && item.minPeMonthlyRentAmt !== ""
                ? Number(item.minPeMonthlyRentAmt)
                : null;
        normalized.mthlyRentAmt = Number(item.mthlyRentAmt || 0);
        // 지도 마커 전용 집계 데이터
        normalized.rentCount = Number(item.rentCount || 0);
        normalized.minMonthlyRentAmt =
            item.minMonthlyRentAmt != null && item.minMonthlyRentAmt !== ""
                ? Number(item.minMonthlyRentAmt)
                : null;

        normalized.maxDpstAmt =
            item.maxDpstAmt != null && item.maxDpstAmt !== ""
                ? Number(item.maxDpstAmt)
                : null;
        normalized.rentLstgCn = nvl(item.rentLstgCn, "등록된 매물 설명이 없습니다.");
        normalized.rcrtBgngDt = nvl(item.rcrtBgngDt);
        normalized.rcrtEndDt = nvl(item.rcrtEndDt);
        normalized.unitCnt = item.unitCnt || 0;
        normalized.dongCnt = item.dongCnt || 0;
        normalized.bldYr = nvl(item.bldYr, "-");
        normalized.cnscoNm = nvl(item.cnscoNm, "-");
        normalized.pkgCnt = item.pkgCnt || 0;
        normalized.ccCnt = item.ccCnt || "-";
        normalized.dongMaxFloor = item.dongMaxFloor || "-";
        normalized.exclusiveSize = item.exclusiveSize || "-";
        normalized.rprsntImgGoogleIds = nvl(item.rprsntImgGoogleIds);

        normalized.rprsntImgGoogleIdList = normalized.rprsntImgGoogleIds
            ? normalized.rprsntImgGoogleIds.split(",").filter(function (googleId) {
                return googleId.trim() !== "";
            }).map(function (googleId) {
                return googleId.trim();
            })
            : [];

        return normalized;
    });
}

/**
 * 검색어, 거래유형 필터 이벤트 연결
 */
function bindEvents() {
    const keywordInput = document.getElementById("rentKeyword");

    if (keywordInput) {
        keywordInput.addEventListener("input", function () {
            renderMarkers();

            if (selectedAptCmplexNo) {
                selectComplex(selectedAptCmplexNo);
            }
        });
    }

    document.querySelectorAll(".filter-btn").forEach(function (btn) {
        btn.addEventListener("click", function () {
            document.querySelectorAll(".filter-btn").forEach(function (item) {
                item.classList.remove("active");
            });

            btn.classList.add("active");
            currentType = btn.dataset.type;

            renderMarkers();

            if (selectedAptCmplexNo) {
                selectComplex(selectedAptCmplexNo);
            }
        });
    });
}

/**
 * 현재 필터 조건에 맞는 단지 마커 목록 반환
 */
function getFilteredList() {
    const keywordEl = document.getElementById("rentKeyword");
    const keyword = keywordEl ? keywordEl.value.trim() : "";

    return complexMarkerList.filter(function (item) {
        const keywordMatched =
            keyword === "" ||
            nvl(item.aptCmplexNm).includes(keyword) ||
            nvl(item.dorojuso).includes(keyword) ||
            nvl(item.sidoNm).includes(keyword) ||
            nvl(item.sigunguNm).includes(keyword) ||
            nvl(item.emdNm).includes(keyword);

        return keywordMatched;
    });
}

/**
 * 단지 번호 기준 현재 로딩된 실제 매물 목록 조회
 */
function getRentListByComplex(aptCmplexNo) {
    return rentListingList.filter(function (item) {
        return item.aptCmplexNo === aptCmplexNo;
    });
}

/**
 * 같은 단지의 매물들을 공고번호 기준으로 묶는다.
 *
 * 예:
 * ANN0024에 연결된 세대 매물 24개
 * → 좌측 카드에서는 공고 카드 1개로 출력
 */
function groupRentListByAnnouncement(complexRentList) {
    const announcementMap = {};

    complexRentList.forEach(function (item) {

        /*
         * 공고번호가 없는 매물은 서로 묶이면 안 되므로
         * 매물번호를 임시 key로 사용한다.
         */
        const key = item.annNo
            ? item.annNo
            : "RENT_" + item.rentLstgNo;

        if (!announcementMap[key]) {
            announcementMap[key] = {
                annNo: item.annNo,
                annTtl: item.annTtl,
                representativeItem: item,
                rentList: [],
                rentNoSet: new Set()
            };
        }

        /*
         * JOIN으로 동일 매물 행이 중복되는 경우까지 방지
         */
        if (!announcementMap[key].rentNoSet.has(item.rentLstgNo)) {
            announcementMap[key].rentNoSet.add(item.rentLstgNo);
            announcementMap[key].rentList.push(item);
        }
    });

    return Object.values(announcementMap).map(function (group) {
        group.supplyCount = group.rentList.length;
        return group;
    });
}

/**
 * 마커용 단지 목록 반환
 *
 * /rent/map-data는 이미 단지별 집계 데이터이므로 그대로 사용한다.
 */
function getComplexMarkerList() {
    return getFilteredList();
}

/**
 * 지도 마커 렌더링
 */
function renderMarkers() {
    clearMarkers();

    if (!map) {
        return;
    }

    const complexList = getComplexMarkerList();

    if (complexList.length === 0) {
        return;
    }

    const bounds = new kakao.maps.LatLngBounds();
    let markerCount = 0;

    complexList.forEach(function (complex) {
        const position = createComplexMarker(complex);

        if (position) {
            bounds.extend(position);
            markerCount++;
        }
    });

    //
    // // 마커가 하나라도 생성된 경우에만 지도 범위 조정
    // if (markerCount > 0) {
    //     map.setBounds(bounds);
    // }

    // 첫 진입 화면은 송파구/강동·하남 인근으로 고정
    if (markerCount > 0 && !selectedAptCmplexNo) {
        map.setCenter(INITIAL_MAP_CENTER);
        map.setLevel(INITIAL_MAP_LEVEL);
        isFirstMapRender = false;
    }
}

/**
 * 단지 마커 생성
 * DB의 LAT_VAL, LON_VAL만 사용한다.
 * 주소검색 geocoder를 사용하지 않아 address.json 반복 호출을 방지한다.
 */
function createComplexMarker(complex) {
    const lat = Number(complex.latVal);
    const lon = Number(complex.lonVal);

    // 좌표가 없거나 숫자가 아니면 마커 생성하지 않음
    if (!lat || !lon || isNaN(lat) || isNaN(lon)) {
        console.warn("단지 좌표 없음. 마커 생성 제외:", complex);
        return null;
    }

    const position = new kakao.maps.LatLng(lat, lon);

    // 같은 단지의 매물들도 선택/이동 시 좌표를 쓸 수 있게 보정
    rentListingList.forEach(function (item) {
        if (item.aptCmplexNo === complex.aptCmplexNo) {
            item.latVal = lat;
            item.lonVal = lon;
        }
    });

    addComplexOverlay(complex, position);

    return position;
}

/**
 * 커스텀 오버레이 추가
 */
function addComplexOverlay(complex, position) {
    const markerContent =
        '<div class="rent-marker" onclick="selectComplex(\'' + escapeJs(complex.aptCmplexNo) + '\')">'
        + escapeHtml(getComplexMarkerText(complex))
        + '</div>';

    const customOverlay = new kakao.maps.CustomOverlay({
        position: position,
        content: markerContent,
        yAnchor: 1.3
    });

    customOverlay.setMap(map);
    markers.push(customOverlay);
}

/**
 * 단지 마커 문구
 *
 * 전체 상태에서는 전세/월세 중 매물 수가 많은 유형의 금액을 표시한다.
 */
function getComplexMarkerText(complex) {
    const jsCount = Number(complex.jsCount || 0);
    const peCount = Number(complex.peCount || 0);

    const minJsDpstAmt = Number(complex.minJsDpstAmt || 0);
    const minPeMonthlyRentAmt = Number(complex.minPeMonthlyRentAmt || 0);

    const maxDpstAmt = Number(complex.maxDpstAmt || 0);
    const minMonthlyRentAmt = Number(complex.minMonthlyRentAmt || 0);

    /*
     * 전세 필터
     */
    if (currentType === "JS") {
        if (minJsDpstAmt > 0) {
            return "전세 " + formatMoneyShort(minJsDpstAmt);
        }

        if (maxDpstAmt > 0) {
            return "전세 " + formatMoneyShort(maxDpstAmt);
        }

        return "전세 -";
    }

    /*
     * 월세 필터
     */
    if (currentType === "PE") {
        if (minPeMonthlyRentAmt > 0) {
            return "월 " + formatMoneyShort(minPeMonthlyRentAmt);
        }

        if (minMonthlyRentAmt > 0) {
            return "월 " + formatMoneyShort(minMonthlyRentAmt);
        }

        return "월 -";
    }

    /*
     * 전체 상태
     * 전세 매물이 더 많거나 같으면 전세 우선
     */
    if (jsCount >= peCount && jsCount > 0) {
        if (minJsDpstAmt > 0) {
            return "전세 " + formatMoneyShort(minJsDpstAmt);
        }

        if (maxDpstAmt > 0) {
            return "전세 " + formatMoneyShort(maxDpstAmt);
        }
    }

    /*
     * 월세 매물이 더 많으면 월세 우선
     */
    if (peCount > jsCount && peCount > 0) {
        if (minPeMonthlyRentAmt > 0) {
            return "월 " + formatMoneyShort(minPeMonthlyRentAmt);
        }

        if (minMonthlyRentAmt > 0) {
            return "월 " + formatMoneyShort(minMonthlyRentAmt);
        }
    }

    /*
     * 집계 개수가 없을 때 fallback
     */
    if (maxDpstAmt > 0) {
        return "전세 " + formatMoneyShort(maxDpstAmt);
    }

    if (minMonthlyRentAmt > 0) {
        return "월 " + formatMoneyShort(minMonthlyRentAmt);
    }

    return "매물";
}

/**
 * 기존 지도 마커 제거
 */
function clearMarkers() {
    markers.forEach(function (marker) {
        marker.setMap(null);
    });

    markers = [];
}

/**
 * 지도 마커 클릭 시 실행
 * 단지별 실제 매물 목록을 서버에서 조회한 뒤 패널을 렌더링한다.
 */
function selectComplex(aptCmplexNo) {
    if (!aptCmplexNo) {
        return;
    }

    selectedAptCmplexNo = aptCmplexNo;

    loadComplexRentList(aptCmplexNo, function (complexRentList) {
        if (!complexRentList || complexRentList.length === 0) {
            alert("해당 단지의 매물 정보를 찾을 수 없습니다.");
            return;
        }

        // 현재 선택 단지의 실제 매물 목록으로 교체
        rentListingList = complexRentList;

        const firstItem = complexRentList[0];
        const page = document.querySelector(".rent-map-page");

        if (page && page.classList.contains("panels-collapsed")) {
            page.classList.remove("panels-collapsed");

            setTimeout(function () {
                if (map) {
                    map.relayout();

                    if (firstItem.latVal != null && firstItem.lonVal != null) {
                        map.panTo(
                            new kakao.maps.LatLng(
                                Number(firstItem.latVal),
                                Number(firstItem.lonVal)
                            )
                        );
                    }
                }
            }, 260);
        } else {
            if (map && firstItem.latVal != null && firstItem.lonVal != null) {
                map.panTo(
                    new kakao.maps.LatLng(
                        Number(firstItem.latVal),
                        Number(firstItem.lonVal)
                    )
                );
            }
        }

        renderComplexRentList(firstItem, complexRentList);
        selectRent(firstItem.rentLstgNo);
    });
}

/**
 * 선택한 단지의 실제 매물 목록 조회
 */
function loadComplexRentList(aptCmplexNo, callback) {
    if (complexRentCache[aptCmplexNo]) {
        callback(complexRentCache[aptCmplexNo]);
        return;
    }

    const contextPath = typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "";
    const apiUrl = contextPath + "/rent/complex-data/" + encodeURIComponent(aptCmplexNo);

    fetch(apiUrl)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("단지별 매물 목록 조회 실패");
            }

            return response.json();
        })
        .then(function (data) {
            console.log("단지별 매물 데이터:", aptCmplexNo, data);

            if (!data.success) {
                alert(data.message || "단지별 매물 목록을 불러오지 못했습니다.");
                callback([]);
                return;
            }

            const list = normalizeRentList(data.list || []);

            complexRentCache[aptCmplexNo] = list;

            callback(list);
        })
        .catch(function (error) {
            console.error("단지별 매물 목록 조회 오류:", error);
            alert("단지별 매물 목록 조회 중 오류가 발생했습니다.");
            callback([]);
        });
}

/**
 * 선택한 단지의 공고별 매물 목록 렌더링
 *
 * 같은 ANN_NO에 연결된 세대 매물은 카드 1개만 출력한다.
 * 카드 클릭 시 해당 공고에 연결된 첫 번째 세대 매물을 상세 패널에 표시한다.
 */
function renderComplexRentList(complexInfo, complexRentList) {
    const complexNameEl = document.getElementById("selectedComplexName");
    const listEl = document.getElementById("complexRentList");

    /* 같은 공고번호의 세대 매물들을 하나의 공고 카드로 묶는다. */
    const announcementList = groupRentListByAnnouncement(complexRentList);

    /* 실제 공급 세대수는 중복 제거된 RENT_LSTG_NO 기준으로 계산한다. */
    const totalSupplyCount = new Set(
        complexRentList.map(function (item) {
            return item.rentLstgNo;
        })
    ).size;

    if (complexNameEl) {
        complexNameEl.innerHTML =
            escapeHtml(complexInfo.aptCmplexNm)
            + '<br><span class="selected-complex-count">· 공고 '
            + announcementList.length
            + '건 / 공급 '
            + totalSupplyCount
            + '세대</span>';
    }

    if (!listEl) {
        return;
    }

    listEl.innerHTML = announcementList.map(function (group) {
        const item = group.representativeItem;

        /* 현재 선택된 세대 매물이 이 공고 그룹에 포함되어 있으면 카드 active 처리 */
        const activeClass = group.rentList.some(function (rent) {
            return rent.rentLstgNo === selectedRentNo;
        }) ? "active" : "";

        /*
         * 공고번호가 있는 카드에만 공고 상세 링크를 표시한다.
         * 카드 전체의 selectRent() 클릭 이벤트와 링크 이동을 분리한다.
         */
        const announcementButtonHtml = group.annNo
            ? ''
            + '<a href="' + escapeHtml(getAnnouncementDetailUrl(group.annNo)) + '"'
            + ' class="complex-ann-link-btn"'
            + ' onclick="rememberAnnouncementReturn(event, \''
            + escapeJs(item.aptCmplexNo)
            + '\', \''
            + escapeJs(item.rentLstgNo)
            + '\', \''
            + escapeJs(group.annNo)
            + '\');">'
            + '  공고확인하기'
            + '  <span class="material-symbols-outlined">arrow_forward</span>'
            + '</a>'
            : '';

        return ''
            + '<article class="complex-rent-card ' + activeClass + '"'
            + ' onclick="selectRent(\'' + escapeJs(item.rentLstgNo) + '\')">'

            + '  <div class="complex-rent-card-top">'
            + '    <span class="rent-type-badge">' + escapeHtml(item.rentTypeNm) + '</span>'
            + '    <span style="font-size:12px; color:#667085;">'
            +          escapeHtml(formatDate(item.rcrtEndDt)) + ' 마감'
            + '    </span>'
            + '  </div>'

            + '  <h3 class="complex-rent-title">'
            +       escapeHtml(item.aptCmplexNm)
            + '  </h3>'

            + '  <p class="complex-rent-price">'
            +       escapeHtml(formatPrice(item))
            + '  </p>'

            + '  <p class="complex-rent-info">'
            + '    공급 ' + escapeHtml(group.supplyCount) + '세대 · '
            +      escapeHtml(item.exclusiveSize) + '㎡<br>'
            +      escapeHtml(item.dorojuso)
            + '  </p>'

            + announcementButtonHtml

            + '</article>';
    }).join("");
}


/**
 * 매물 선택
 */
function selectRent(rentLstgNo) {
    const item = rentListingList.find(function (rent) {
        return rent.rentLstgNo === rentLstgNo;
    });

    if (!item) {
        return;
    }

    selectedRentNo = rentLstgNo;
    selectedAptCmplexNo = item.aptCmplexNo;

    const page = document.querySelector(".rent-map-page");

    if (page && page.classList.contains("panels-collapsed")) {
        page.classList.remove("panels-collapsed");

        setTimeout(function () {
            if (map) {
                map.relayout();
            }
        }, 260);
    }

    renderDetail(item);

    const complexRentList = getRentListByComplex(item.aptCmplexNo);

    if (complexRentList.length > 0) {
        renderComplexRentList(item, complexRentList);
    }
}

/**
 * 가운데 상세 패널 렌더링
 */
function renderDetail(item) {
    const heroEl = document.getElementById("rentDetailHero");
    const detailEl = document.getElementById("rentDetail");

    if (!detailEl) {
        return;
    }

    if (heroEl) {
        heroEl.className = "rent-detail-hero-area";

        const imageList = item.rprsntImgGoogleIdList || [];

        if (imageList.length > 0) {
            const contextPath = typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "";

            let sliderHtml = '<div class="rent-detail-slider">';

            imageList.forEach(function (googleId, index) {
                const imageUrl =
                    contextPath + "/file/display/" + encodeURIComponent(googleId);

                sliderHtml += ''
                    + '<img src="' + escapeHtml(imageUrl) + '"'
                    + ' alt="' + escapeHtml(item.aptCmplexNm) + '"'
                    + ' class="rent-detail-hero-image ' + (index === 0 ? 'active' : '') + '"'
                    + ' onerror="this.style.display=\'none\';">';
            });

            if (imageList.length > 1) {
                sliderHtml += ''
                    + '<button type="button" class="rent-slider-btn prev" onclick="moveRentDetailSlide(-1)">'
                    + '  <span class="material-symbols-outlined">chevron_left</span>'
                    + '</button>'
                    + '<button type="button" class="rent-slider-btn next" onclick="moveRentDetailSlide(1)">'
                    + '  <span class="material-symbols-outlined">chevron_right</span>'
                    + '</button>';
            }

            sliderHtml += '</div>';

            heroEl.innerHTML = sliderHtml;
        } else {
            heroEl.innerHTML = createEmptyImageHtml();
        }
    }

    detailEl.className = "";
    detailEl.innerHTML = ''
        + '<div class="rent-detail-content">'
        + '  <span class="rent-type-badge">' + escapeHtml(item.rentTypeNm) + '</span>'
        + '  <h2>' + escapeHtml(item.aptCmplexNm) + '</h2>'
        + '  <p style="color:#667085; margin-top:0;">' + escapeHtml(item.dongNm) + '동 ' + escapeHtml(item.ho) + '호</p>'
        + '  <div class="rent-detail-price">' + escapeHtml(formatPrice(item)) + '</div>'

        + '  <div class="rent-info-grid">'
        + '    <div class="rent-info-item"><span class="rent-info-label">전용면적</span><span class="rent-info-value">' + escapeHtml(item.exclusiveSize) + '㎡</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">층수</span><span class="rent-info-value">' + escapeHtml(item.floor) + '층 / 최고 ' + escapeHtml(item.dongMaxFloor) + '층</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">호 상태</span><span class="rent-info-value">' + escapeHtml(item.empty) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">모집 기간</span><span class="rent-info-value">' + escapeHtml(formatDate(item.rcrtBgngDt)) + ' ~ ' + escapeHtml(formatDate(item.rcrtEndDt)) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">세대수</span><span class="rent-info-value">' + escapeHtml(formatNumber(item.unitCnt)) + '세대</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">동수</span><span class="rent-info-value">' + escapeHtml(item.dongCnt) + '동</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">준공년도</span><span class="rent-info-value">' + escapeHtml(item.bldYr) + '</span></div>'
        + '    <div class="rent-info-item"><span class="rent-info-label">건설사</span><span class="rent-info-value">' + escapeHtml(nvl(item.cnscoNm, "-")) + '</span></div>'
        + '  </div>'

        + '  <h3 class="rent-detail-section-title">주소</h3>'
        + '  <p class="rent-detail-desc">' + escapeHtml(item.dorojuso) + '</p>'

        + '  <h3 class="rent-detail-section-title">매물 설명</h3>'
        + '  <p class="rent-detail-desc">' + escapeHtml(item.rentLstgCn) + '</p>'

        + '  <button type="button" class="rent-detail-btn" onclick="goRentDetail(\'' + escapeJs(item.rentLstgNo) + '\')">'
        + '    매물 상세보기'
        + '  </button>'
        + '</div>';
}

/**
 * 단지 대표 이미지가 없는 경우 표시할 HTML
 */
function createEmptyImageHtml() {
    return ''
        + '<div class="rent-detail-empty-image">'
        + '  <span class="material-symbols-outlined">image</span>'
        + '  <p>해당 이미지가 없습니다.</p>'
        + '</div>';
}

/**
 * 가운데 상세 패널 이미지 슬라이드 이동
 */
function moveRentDetailSlide(direction) {
    const images = document.querySelectorAll("#rentDetailHero .rent-detail-hero-image");

    if (!images || images.length <= 1) {
        return;
    }

    let currentIndex = 0;

    images.forEach(function (image, index) {
        if (image.classList.contains("active")) {
            currentIndex = index;
        }
    });

    images[currentIndex].classList.remove("active");

    let nextIndex = currentIndex + direction;

    if (nextIndex < 0) {
        nextIndex = images.length - 1;
    }

    if (nextIndex >= images.length) {
        nextIndex = 0;
    }

    images[nextIndex].classList.add("active");
}
/**
 * 단지 매물목록 + 상세 패널 닫기
 */
function closeRentPanels() {
    const page = document.querySelector(".rent-map-page");

    if (!page) {
        return;
    }

    page.classList.add("panels-collapsed");

    setTimeout(function () {
        if (map) {
            map.relayout();

        }
    }, 260);
}

/**
 * 가격 표시
 */
function formatPrice(item) {
    if (item.rentTypeCd === "JS") {
        return "전세 " + formatMoney(item.dpstAmt);
    }

    if (item.rentTypeCd === "PE") {
        return "보증금 " + formatMoney(item.dpstAmt) + " / 월 " + formatMoney(item.mthlyRentAmt);
    }

    return formatMoney(item.dpstAmt);
}

/**
 * 금액 포맷
 * DB 금액은 원 단위 기준
 */
function formatMoney(value) {
    if (value == null || value === "") {
        return "-";
    }

    const num = Number(value);

    if (num === 0) {
        return "0원";
    }

    const eok = Math.floor(num / 100000000);
    const man = Math.floor((num % 100000000) / 10000);

    if (eok > 0 && man > 0) {
        return eok + "억 " + man.toLocaleString() + "만";
    }

    if (eok > 0) {
        return eok + "억";
    }

    if (man > 0) {
        return man.toLocaleString() + "만";
    }

    return num.toLocaleString() + "원";
}

/**
 * 마커용 짧은 금액 포맷
 */
function formatMoneyShort(value) {
    if (value == null || value === "") {
        return "-";
    }

    const num = Number(value);

    if (num === 0) {
        return "0";
    }

    const eok = Math.floor(num / 100000000);
    const man = Math.floor((num % 100000000) / 10000);

    if (eok > 0 && man > 0) {
        return eok + "." + Math.floor(man / 1000) + "억";
    }

    if (eok > 0) {
        return eok + "억";
    }

    if (man > 0) {
        return man.toLocaleString() + "만";
    }

    return num.toLocaleString();
}

/**
 * 숫자 콤마
 */
function formatNumber(value) {
    if (value == null || value === "") {
        return "-";
    }

    return Number(value).toLocaleString();
}

/**
 * 날짜 표시
 */
function formatDate(value) {
    if (value == null || value === "") {
        return "-";
    }

    if (typeof value === "string") {
        if (/^\d{8}$/.test(value)) {
            return value.substring(0, 4) + "-" + value.substring(4, 6) + "-" + value.substring(6, 8);
        }

        return value.substring(0, 10);
    }

    return value;
}

/**
 * null 방어
 */
function nvl(value, defaultValue) {
    if (defaultValue === undefined) {
        defaultValue = "";
    }

    if (value == null || value === "") {
        return defaultValue;
    }

    return String(value);
}

/**
 * HTML escape
 */
function escapeHtml(value) {
    if (value == null) {
        return "";
    }

    return String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

/**
 * onclick 문자열 escape
 */
function escapeJs(value) {
    if (value == null) {
        return "";
    }

    return String(value).replaceAll("\\", "\\\\").replaceAll("'", "\\'");
}

/**
 * 매물 상세 페이지 이동
 * 상세페이지에서 뒤로가기 했을 때도 현재 선택 상태를 복원할 수 있도록 저장한다.
 */
function goRentDetail(rentLstgNo) {
    const contextPath = typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "";

    const selectedItem = rentListingList.find(function (item) {
        return item.rentLstgNo === rentLstgNo;
    });

    if (selectedItem) {
        saveRentMapSelection(
            selectedItem.aptCmplexNo,
            selectedItem.rentLstgNo,
            selectedItem.annNo
        );
    }

    location.href = contextPath + "/rent/detail/" + encodeURIComponent(rentLstgNo);
}

/**
 * 공고확인하기 버튼 클릭 시 현재 선택 상태를 저장한다.
 * 실제 페이지 이동은 a 태그의 href가 그대로 처리한다.
 */
function rememberAnnouncementReturn(event, aptCmplexNo, rentLstgNo, annNo) {
    if (event) {
        event.stopPropagation();
    }

    saveRentMapSelection(aptCmplexNo, rentLstgNo, annNo);
}

/**
 * 현재 선택 중인 단지와 매물을 현재 브라우저 탭에 임시 저장한다.
 */
function saveRentMapSelection(aptCmplexNo, rentLstgNo, annNo) {
    if (!aptCmplexNo) {
        return;
    }

    const restoreState = {
        aptCmplexNo: aptCmplexNo,
        rentLstgNo: rentLstgNo || "",
        annNo: annNo || "",
        savedAt: new Date().getTime()
    };

    try {
        sessionStorage.setItem(
            RENT_MAP_RESTORE_KEY,
            JSON.stringify(restoreState)
        );
    } catch (error) {
        console.warn("매물 지도 선택 상태 저장 실패:", error);
    }
}

/**
 * 공고 상세페이지 또는 매물 상세페이지에서 뒤로 돌아왔을 때
 * 이전에 선택했던 단지와 매물을 다시 연다.
 */
function restoreRentMapSelection() {
    let savedStateText = "";

    try {
        savedStateText = sessionStorage.getItem(RENT_MAP_RESTORE_KEY);

        if (!savedStateText) {
            return;
        }

        /*
         * 한 번 복원한 뒤에는 제거한다.
         * 이후 지도 화면에 새로 접속했을 때까지 자동으로 열리는 것을 방지한다.
         */
        sessionStorage.removeItem(RENT_MAP_RESTORE_KEY);
    } catch (error) {
        console.warn("매물 지도 선택 상태 읽기 실패:", error);
        return;
    }

    let savedState;

    try {
        savedState = JSON.parse(savedStateText);
    } catch (error) {
        console.warn("매물 지도 선택 상태 변환 실패:", error);
        return;
    }

    if (!savedState || !savedState.aptCmplexNo) {
        return;
    }

    /*
     * 이전에 선택했던 대표 매물이 있으면
     * 단지 패널과 가운데 상세 패널까지 동일하게 복원한다.
     */
    const savedRent = rentListingList.find(function (item) {
        return item.rentLstgNo === savedState.rentLstgNo
            && item.aptCmplexNo === savedState.aptCmplexNo;
    });

    if (savedRent) {
        selectComplex(savedRent.aptCmplexNo);
        selectRent(savedRent.rentLstgNo);
        return;
    }

    /*
     * 대표 매물을 찾지 못한 경우에는 단지 패널까지만 다시 연다.
     */
    selectComplex(savedState.aptCmplexNo);
}

/**
 * 공고 상세 페이지 URL 생성
 * ContractUserController: GET /contract/detail.do?annNo={annNo}
 */
function getAnnouncementDetailUrl(annNo) {
    const contextPath = typeof CONTEXT_PATH !== "undefined" ? CONTEXT_PATH : "";

    if (!annNo) {
        return "#";
    }

    return contextPath
        + "/contract/detail.do?annNo="
        + encodeURIComponent(annNo);
}

/**
 * 데이터 없음 메시지
 */
function showEmptyMapMessage() {
    const listEl = document.getElementById("complexRentList");

    if (listEl) {
        listEl.innerHTML =
            '<div class="rent-empty-message">등록된 매물이 없습니다.</div>';
    }
}


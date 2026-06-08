import { useEffect, useState } from 'react';

import { Card } from '../common/Card';
import AptUnitEditor from './AptUnitEditor';
import '../../styles/sales/AptDetailPanel.css';

const EMPTY_COMPLEX = {
    aptCmplexNm: '',
    cnscoNm: '',
    dorojuso: '',

    unitCnt: 0,
    dongCnt: 0,
    maxFloor: 0,

    pkgCnt: 0,
    freePkgCnt: 0,
    ccCnt: 0,

    heatTy: '',
};

const AptDetailPanel = ({
    detailData,

    complex,
    setComplex,

    unitList,
    setUnitList,
}) => {

    /**
     * 동 정보 변경시
     * 세대수 / 동수 / 최고층 자동계산
     */
    useEffect(() => {

        const totalUnitCnt =
            unitList.reduce(
                (sum, unit) =>
                    sum +
                    (unit.unitCnt || 0),
                0
            );

        const maxFloor =
            Math.max(
                ...unitList.map(
                    unit =>
                        unit.floor || 0
                ),
                0
            );

        setComplex(prev => ({
            ...prev,

            unitCnt:
                totalUnitCnt,

            dongCnt:
                unitList.length,

            maxFloor:
                maxFloor,
        }));

    }, [unitList]);

    return (

        <div className="apt-detail-wrap">

            {/* 기본정보 */}
            <Card title="기본 정보">

                <div className="apt-basic-grid">

                    <div className="apt-form-group">

                        <label>
                            아파트명
                        </label>

                        <input
                            className="c-input"
                            value={
                                complex.aptCmplexNm
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    aptCmplexNm:
                                        e.target.value,
                                }))
                            }
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            건설사
                        </label>

                        <input
                            className="c-input"
                            value={
                                complex.cnscoNm
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    cnscoNm:
                                        e.target.value,
                                }))
                            }
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            난방방식
                        </label>

                        <select
                            className="c-select"
                            value={
                                complex.heatTy
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    heatTy:
                                        e.target.value,
                                }))
                            }
                        >

                            <option value="">
                                선택
                            </option>

                            <option value="개별난방">
                                개별난방
                            </option>

                            <option value="중앙난방">
                                중앙난방
                            </option>

                            <option value="지역난방">
                                지역난방
                            </option>

                        </select>

                    </div>

                    <div className="apt-form-group apt-full">

                        <label>
                            도로명주소
                        </label>

                        <input
                            className="c-input"
                            value={
                                complex.dorojuso
                            }
                            readOnly
                        />

                    </div>

                </div>

            </Card>

            {/* 단지 현황 */}
            <Card title="단지 현황">

                <div className="apt-status-grid">

                    <div className="apt-form-group">

                        <label>
                            세대수
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.unitCnt
                            }
                            readOnly
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            동수
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.dongCnt
                            }
                            readOnly
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            최고층
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.maxFloor
                            }
                            readOnly
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            주차 가능 대수
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.pkgCnt
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    pkgCnt:
                                        Number(
                                            e.target.value
                                        ) || 0,
                                }))
                            }
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            무료 주차 대수
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.freePkgCnt
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    freePkgCnt:
                                        Number(
                                            e.target.value
                                        ) || 0,
                                }))
                            }
                        />

                    </div>

                    <div className="apt-form-group">

                        <label>
                            CCTV 수
                        </label>

                        <input
                            type="number"
                            className="c-input"
                            value={
                                complex.ccCnt
                            }
                            onChange={(e) =>
                                setComplex(prev => ({
                                    ...prev,
                                    ccCnt:
                                        Number(
                                            e.target.value
                                        ) || 0,
                                }))
                            }
                        />

                    </div>

                </div>

            </Card>

            {/* 동 정보 */}
            <Card title="동 정보">

                <AptUnitEditor
                    unitList={unitList}
                    setUnitList={setUnitList}
                />

            </Card>

        </div>

    );
};

export default AptDetailPanel;
import { useEffect, useRef, useState } from 'react';
import '../../styles/sales/AptUnitEditor.css';

const AptUnitEditor = ({
    unitList,
    setUnitList,
}) => {

    const [activeIdx, setActiveIdx] =
        useState(0);

    const tabsRef =
        useRef(null);

    useEffect(() => {

        if (
            activeIdx >= unitList.length
        ) {

            setActiveIdx(0);
        }

    }, [unitList, activeIdx]);

    const scrollTabs = (
        direction
    ) => {

        if (!tabsRef.current) {
            return;
        }

        tabsRef.current.scrollBy({
            left: direction * 250,
            behavior: 'smooth',
        });
    };

    if (!unitList?.length) {

        return (
            <div className="apt-unit-empty">
                동 정보가 없습니다.
            </div>
        );
    }

    const currentUnit =
        unitList[activeIdx];

    const handleChange = (
        key,
        value
    ) => {

        setUnitList(prev => {

            const copy = [...prev];

            copy[activeIdx] = {
                ...copy[activeIdx],
                [key]: value,
            };

            return copy;
        });
    };

    const handleFloorChange = (
        floor
    ) => {

        const floorUnitCnt =
            currentUnit.floorUnitCnt || 0;

        setUnitList(prev => {

            const copy = [...prev];

            copy[activeIdx] = {
                ...copy[activeIdx],
                floor,
                unitCnt:
                    floor * floorUnitCnt,
            };

            return copy;
        });
    };

    const handleFloorUnitChange = (
        floorUnitCnt
    ) => {

        const floor =
            currentUnit.floor || 0;

        setUnitList(prev => {

            const copy = [...prev];

            copy[activeIdx] = {
                ...copy[activeIdx],
                floorUnitCnt,
                unitCnt:
                    floor * floorUnitCnt,
            };

            return copy;
        });
    };

    return (

        <div className="apt-unit-editor">

            <div className="apt-unit-tabs-wrap">

                {unitList.length > 5 && (

                    <button
                        type="button"
                        className="apt-tab-arrow"
                        onClick={() =>
                            scrollTabs(-1)
                        }
                    >
                        ‹
                    </button>

                )}

                <div
                    className="apt-unit-tabs"
                    ref={tabsRef}
                >

                    {unitList.map(
                        (unit, idx) => (

                            <button
                                key={
                                    unit.dongNo || idx
                                }
                                type="button"
                                className={
                                    `apt-unit-tab ${activeIdx === idx
                                        ? 'active'
                                        : ''
                                    }`
                                }
                                onClick={() =>
                                    setActiveIdx(idx)
                                }
                            >
                                {unit.dongNm}동
                            </button>

                        )
                    )}

                </div>

                {unitList.length > 5 && (

                    <button
                        type="button"
                        className="apt-tab-arrow"
                        onClick={() =>
                            scrollTabs(1)
                        }
                    >
                        ›
                    </button>

                )}

            </div>

            <div className="apt-unit-form">

                <div className="apt-form-row">

                    <label>
                        동명
                    </label>

                    <input
                        className="c-input"
                        value={
                            currentUnit.dongNm || ''
                        }
                        onChange={(e) =>
                            handleChange(
                                'dongNm',
                                e.target.value
                            )
                        }
                    />

                </div>

                <div className="apt-form-row">

                    <label>
                        층수
                    </label>

                    <input
                        type="number"
                        className="c-input"
                        value={
                            currentUnit.floor || 0
                        }
                        onChange={(e) =>
                            handleFloorChange(
                                Number(
                                    e.target.value
                                )
                            )
                        }
                    />

                </div>

                <div className="apt-form-row">

                    <label>
                        층당 세대수
                    </label>

                    <input
                        type="number"
                        className="c-input"
                        value={
                            currentUnit.floorUnitCnt || 0
                        }
                        onChange={(e) =>
                            handleFloorUnitChange(
                                Number(
                                    e.target.value
                                )
                            )
                        }
                    />

                </div>

                <div className="apt-form-row">

                    <label>
                        세대수
                    </label>

                    <input
                        type="number"
                        className="c-input"
                        value={
                            currentUnit.unitCnt || 0
                        }
                        readOnly
                    />

                </div>

            </div>

        </div>

    );
};

export default AptUnitEditor;
package com.coffee.backend.domain.company.service;

import com.coffee.backend.domain.company.dto.CompanyRequestDto;
import com.coffee.backend.domain.company.dto.CompanyRequestRequest;
import com.coffee.backend.domain.company.entity.CompanyRequest;
import com.coffee.backend.domain.company.repository.CompanyRequestRepository;
import com.coffee.backend.domain.user.entity.User;
import com.coffee.backend.exception.CustomException;
import com.coffee.backend.exception.ErrorCode;
import com.coffee.backend.utils.CustomMapper;
import jakarta.transaction.Transactional;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CompanyRequestService {

    private final CompanyRequestRepository companyRequestRepository;
    private final CustomMapper customMapper;

    public CompanyRequestRequest saveRequest(User user, CompanyRequestRequest dto) {
        companyRequestRepository.save(CompanyRequest.builder()
                .name(dto.getName())
                .domain(dto.getDomain())
                .bno(dto.getBno())
                .user(user).build()
        );
        return dto;
    }

    public void deleteRequest(Long companyRequestId) {
        companyRequestRepository.delete(companyRequestRepository.findById(companyRequestId).orElseThrow(() -> {
                    log.info("id = {} 인 company_request 가 존재하지 않습니다", companyRequestId);
                    return new CustomException(ErrorCode.COMPANY_REQUEST_NOT_FOUND);
                }
        ));
    }

    public List<CompanyRequestDto> findAllRequests() {
        return companyRequestRepository.findAll().stream()
                .map(cr -> CompanyRequestDto.builder().id(cr.getCompanyRequestId())
                        .name(cr.getName())
                        .domain(cr.getDomain())
                        .bno(cr.getBno())
                        .user(customMapper.toUserDto(cr.getUser())).build()).toList();
    }
}
